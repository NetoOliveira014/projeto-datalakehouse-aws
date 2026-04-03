-- Cria a tabela que o Power BI vai ler
CREATE TABLE metricas_iot (
    device_id VARCHAR(50),
    data_particao DATE,
    temp_media FLOAT,
    temp_maxima FLOAT,
    umidade_minima FLOAT
);

-- Comando COPY (Acionado após o ETL 2)
COPY metricas_iot
FROM 's3://datalake-gold-seu-nome/metricas_diarias/'
IAM_ROLE 'arn:aws:iam::SUACONTA:role/S3RedshiftRole'
FORMAT AS PARQUET;