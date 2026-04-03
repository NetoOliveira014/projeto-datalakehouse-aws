import sys
from pyspark.context import SparkContext #type: ignore
from awsglue.context import GlueContext #type: ignore
from pyspark.sql.functions import col, to_date, year, month, dayofmonth

# Inicializa o cluster Spark
glueContext = GlueContext(SparkContext())
spark = glueContext.spark_session

CAMINHO_BRONZE = "s3://datalake-bronze-seu-nome/"
CAMINHO_SILVER = "s3://datalake-silver-seu-nome/dados_iot/"

# 1. Extração: Lê os arquivos agrupados pelo Firehose
df_bronze = spark.read.json(CAMINHO_BRONZE)

# 2. Transformação: Filtra lixo e cria colunas de data para particionamento
df_silver = df_bronze \
    .filter(col("temperatura").isNotNull()) \
    .withColumn("data_particao", to_date(col("timestamp"))) \
    .withColumn("ano", year(col("data_particao"))) \
    .withColumn("mes", month(col("data_particao"))) \
    .withColumn("dia", dayofmonth(col("data_particao")))

# 3. Carga: Salva em formato colunar (Parquet), particionado por data
df_silver.write \
    .mode("append") \
    .partitionBy("ano", "mes", "dia") \
    .parquet(CAMINHO_SILVER)