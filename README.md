# Data Lakehouse AWS: Pipeline IoT Serverless (Arquitetura Medallion)

Bem-vindo(a) ao repositório do projeto **Data Lakehouse AWS**! 🚀

Este projeto é uma simulação de ponta a ponta de um pipeline de Engenharia de Dados focado em telemetria IoT. O objetivo é demonstrar como ingerir, processar, armazenar e orquestrar grandes volumes de dados na nuvem AWS, utilizando serviços 100% gerenciados (Serverless) e aplicando os conceitos modernos da **Arquitetura Medallion** (Camadas Bronze, Silver e Gold).

Se você é da área de dados ou está estudando para entrar nela, este repositório serve como um guia prático para você replicar essa infraestrutura na sua própria conta AWS!

---

## Arquitetura do Projeto

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

Como Replicar este Projeto (Guia Passo a Passo)
Pré-requisitos
Conta na AWS (Nível Gratuito / Free Tier aplicável para a maioria dos serviços, cuidado com custos de Glue e Redshift).

AWS CLI instalado e configurado na sua máquina local (aws configure).

Python 3 instalado.

Passo 1: Configuração Local
Clone este repositório e crie um ambiente virtual para instalar as dependências do simulador.

Bash
git clone [https://github.com/SEU_USUARIO/projeto-datalakehouse-aws.git](https://github.com/SEU_USUARIO/projeto-datalakehouse-aws.git)
cd projeto-datalakehouse-aws
python3 -m venv .venv
source .venv/bin/activate
pip install boto3 pyspark

Passo 2: Infraestrutura de Armazenamento e Segurança
1.Execute o script infraestrutura/01_setup_s3.sh para criar seus buckets (Altere a variável de sufixo no arquivo para gerar nomes globalmente únicos).

2.Acesse o console do AWS IAM e crie 3 Roles (Funções):

Role para o Kinesis gravar no S3.

Role para o Glue (com AWSGlueServiceRole e acesso de leitura/escrita no S3).

Role para o Step Functions acionar o Glue e o SNS.

Passo 3: Ingestão de Dados

1.No console da AWS, crie um Kinesis Data Firehose do tipo Direct PUT.

2.Aponte o destino para o seu bucket S3 da camada Bronze.

3.Atualize a variável STREAM_NAME dentro do arquivo ingestao/02_simulador_iot.py e rode o script:

Bash
python ingestao/02_simulador_iot.py
(Deixe o script rodando por alguns minutos para gerar volume de dados).

Passo 4: Configurando os ETLs (AWS Glue)

1.Vá ao AWS Glue > ETL Jobs e crie dois novos jobs do tipo Spark script editor.

2.Copie e cole os códigos da pasta processamento_etl/.

3.Lembre-se de alterar as URIs dos caminhos do S3 (s3://...) dentro do código para o nome dos seus buckets.

4.Anexe a IAM Role do Glue criada no Passo 2.

Passo 5: Orquestração e Alertas (SNS e Step Functions)
Configurando Alertas (Amazon SNS):

1.Acesse o console do Amazon SNS e crie um novo Tópico do tipo Standard (Nomeie como Alerta-DataLake).

Dentro do tópico criado, clique em Create subscription (Criar inscrição).

Escolha o protocolo Email e digite o seu endereço de e-mail.

Passo crucial: Vá até a sua caixa de entrada de e-mail, abra a mensagem da AWS e clique em Confirm subscription.

Copie o ARN do seu Tópico SNS (Ex: arn:aws:sns:us-east-1:123456789:Alerta-DataLake).

2.Criando a Máquina de Estados (AWS Step Functions):

Vá ao console do Step Functions e crie uma nova State Machine (Escolha o modelo em branco / Write your workflow in code).

Cole o conteúdo do nosso arquivo orquestracao/step_functions.json.

Substitua os ARNs genéricos no JSON pelos ARNs reais da sua conta (Os ARNs dos jobs do Glue e o ARN do Tópico SNS que você acabou de copiar).

3.Criando o Gatilho (Amazon EventBridge):

O agendamento para rodar o pipeline diariamente pode ser criado pelo console ou executando o nosso script via terminal:

Bash
bash infraestrutura/06_eventbridge_trigger.sh

Passo 6: Execução e Consumo!
Agora, basta iniciar a execução da sua State Machine no console do Step Functions. Você verá visualmente cada etapa (Limpeza e Agregação) ficando verde. No final, os dados processados estarão no seu bucket Gold, prontos para serem consumidos via Athena ou copiados para o Redshift usando o script da pasta data_warehouse/!
