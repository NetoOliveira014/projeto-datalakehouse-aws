import sys
from pyspark.context import SparkContext #type: ignore
from awsglue.context import GlueContext #type: ignore
from pyspark.sql.functions import avg, max, min

glueContext = GlueContext(SparkContext())
spark = glueContext.spark_session

CAMINHO_SILVER = "s3://datalake-silver-seu-nome/dados_iot/"
CAMINHO_GOLD = "s3://datalake-gold-seu-nome/metricas_diarias/"

df_silver = spark.read.parquet(CAMINHO_SILVER)

# Agregações: Média, Máxima e Mínima por sensor e por dia
df_gold = df_silver.groupBy("device_id", "data_particao") \
    .agg(
        avg("temperatura").alias("temp_media"),
        max("temperatura").alias("temp_maxima"),
        min("umidade").alias("umidade_minima")
    )

# Salva a tabela final pronta para consumo
df_gold.write.mode("overwrite").parquet(CAMINHO_GOLD)