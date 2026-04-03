# Data Lakehouse AWS: Pipeline IoT Serverless (Arquitetura Medallion)

Bem-vindo(a) ao repositório do projeto **Data Lakehouse AWS**! 🚀

Este projeto é uma simulação de ponta a ponta de um pipeline de Engenharia de Dados focado em telemetria IoT. O objetivo é demonstrar como ingerir, processar, armazenar e orquestrar grandes volumes de dados na nuvem AWS, utilizando serviços 100% gerenciados (Serverless) e aplicando os conceitos modernos da **Arquitetura Medallion** (Camadas Bronze, Silver e Gold).

Se você é da área de dados ou está estudando para entrar nela, este repositório serve como um guia prático para você replicar essa infraestrutura na sua própria conta AWS!

---

## Arquitetura do Projeto

![Diagrama da Arquitetura](diagramas/arquitetura_aws.png)
*(Nota: Certifique-se de que a imagem `arquitetura_aws.png` está na pasta `diagramas` do seu repositório).*

### Fluxo de Dados (Data Flow):
1. **Origem:** Um script Python atua como simulador, gerando dados fictícios de sensores IoT (Temperatura e Umidade) em tempo real.
2. **Ingestão (Streaming/Batch):** O Amazon Kinesis Data Firehose recebe os dados, faz o agrupamento (buffer) e entrega lotes de arquivos JSON diretamente no Data Lake.
3. **Data Lake (S3):** Dividido em três camadas:
   * **Bronze:** Dados brutos (Raw) em JSON.
   * **Silver:** Dados limpos, filtrados e convertidos para o formato colunar Parquet (otimizado para performance e custo).
   * **Gold:** Dados agregados e regras de negócio aplicadas (Métricas diárias).
4. **Processamento (ETL):** O AWS Glue (Apache Spark) é responsável por ler os dados de uma camada, transformá-los e gravá-los na próxima.
5. **Orquestração:** O AWS Step Functions atua como o "maestro", coordenando a ordem de execução dos scripts ETL e lidando com falhas. O gatilho diário é feito pelo Amazon EventBridge.
6. **Notificações:** O Amazon SNS envia alertas por e-mail sobre o sucesso ou falha do pipeline.
7. **Consumo:** Amazon Redshift (Data Warehouse) e Amazon Athena para consultas analíticas e dashboards.

---

## Stack Tecnológico

* **Linguagem:** Python 3, PySpark, SQL, Bash.
* **Cloud Provider (AWS):**
  * Armazenamento: Amazon S3
  * Ingestão: Amazon Kinesis Data Firehose
  * Processamento ETL: AWS Glue (Spark Serverless)
  * Banco de Dados: Amazon Redshift (ou Athena)
  * Orquestração: AWS Step Functions, Amazon EventBridge
  * Segurança & Alertas: AWS IAM, Amazon SNS

---

## Estrutura do Repositório

```text
projeto-datalakehouse-aws/
├── diagramas/
│   └── arquitetura_aws.png
├── infraestrutura/
│   ├── 01_setup_s3.sh
│   └── 06_eventbridge_trigger.sh
├── ingestao/
│   └── 02_simulador_iot.py
├── processamento_etl/
│   ├── 03_glue_job_1_limpeza.py
│   └── 04_glue_job_2_agregacao.py
├── data_warehouse/
│   └── 05_redshift_copy.sql
├── orquestracao/
│   └── step_functions.json
└── README.md
