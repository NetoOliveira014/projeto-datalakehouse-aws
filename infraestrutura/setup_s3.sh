# Script: 01_setup_s3.sh
# Descrição: Criação dos buckets S3 para a arquitetura Medallion (Data Lake)
# IMPORTANTE: Os nomes de buckets no S3 precisam ser globais e únicos.
# Altere a variável abaixo para evitar erros de "Bucket already exists".

SUFIXO_UNICO="seu-nome-iot-datalake"
REGIAO="us-east-1"

# Definição das camadas
BUCKET_BRONZE="datalake-bronze-$SUFIXO_UNICO"
BUCKET_SILVER="datalake-silver-$SUFIXO_UNICO"
BUCKET_GOLD="datalake-gold-$SUFIXO_UNICO"

echo "Iniciando a criação da infraestrutura do Data Lake no Amazon S3..."

# 1. Cria a Camada Bronze (Raw Data - Arquivos JSON brutos)
echo "Criando Camada Bronze: s3://$BUCKET_BRONZE"
aws s3 mb s3://$BUCKET_BRONZE --region $REGIAO

# 2. Cria a Camada Silver (Clean Data - Arquivos limpos em Parquet)
echo "Criando Camada Silver: s3://$BUCKET_SILVER"
aws s3 mb s3://$BUCKET_SILVER --region $REGIAO

# 3. Cria a Camada Gold (Aggregated Data - Métricas de negócio em Parquet)
echo "Criando Camada Gold:   s3://$BUCKET_GOLD"
aws s3 mb s3://$BUCKET_GOLD --region $REGIAO

echo "Sucesso! Buckets criados perfeitamente."