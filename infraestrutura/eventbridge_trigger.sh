# Script: 06_eventbridge_trigger.sh
# Descrição: Criação da regra de agendamento (Cron) no Amazon EventBridge
# para disparar o orquestrador AWS Step Functions diariamente.
# Variáveis (Quem clonar o projeto precisa substituir pelo ID da própria conta AWS)

AWS_ACCOUNT_ID="123456789012" # Substitua pelo ID numérico da sua conta AWS
REGIAO="us-east-1"

# Nomes dos recursos
RULE_NAME="Trigger-Diario-DataLake-IoT"
CRON_EXPRESSION="cron(0 0 * * ? *)" # Roda todo dia à meia-noite (UTC)
STATE_MACHINE_NAME="MeuOrquestradorIoT" # Nome dado ao Step Functions
ROLE_NAME="EventBridgeInvokeStepFunctionsRole" # IAM Role com permissão de disparo

echo "⏰ Criando a regra de agendamento no Amazon EventBridge..."

# 1. Cria a regra de tempo (O "Despertador")
aws events put-rule \
    --name "$RULE_NAME" \
    --schedule-expression "$CRON_EXPRESSION" \
    --state "ENABLED" \
    --description "Acorda o pipeline do Step Functions (IoT) todo dia a meia-noite" \
    --region $REGIAO

echo "Conectando a regra ao alvo (Step Functions)..."

# 2. Define o alvo (Quem será acordado)
aws events put-targets \
    --rule "$RULE_NAME" \
    --targets "Id"="1","Arn"="arn:aws:states:$REGIAO:$AWS_ACCOUNT_ID:stateMachine:$STATE_MACHINE_NAME","RoleArn"="arn:aws:iam::$AWS_ACCOUNT_ID:role/$ROLE_NAME" \
    --region $REGIAO

echo "Gatilho configurado com sucesso! O pipeline rodará automaticamente."