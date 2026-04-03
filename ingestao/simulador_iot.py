import boto3
import json
import time
import random
from datetime import datetime

# Conecta ao Firehose usando as credenciais configuradas na sua máquina
firehose = boto3.client('firehose', region_name='us-east-1')
STREAM_NAME = 'firehose-ingestao-iot'

print("Iniciando envio de dados IoT...")

while True:
    # 1. Gera o dado de telemetria
    payload = {
        "device_id": f"sensor_{random.randint(1,5)}",
        "temperatura": round(random.uniform(20.0, 38.0), 2),
        "umidade": round(random.uniform(40.0, 85.0), 2),
        "timestamp": datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    }
    
    # 2. Converte para string e adiciona quebra de linha (Crucial para o Athena/Glue lerem linha a linha no S3)
    record = json.dumps(payload) + '\n'
    
    # 3. Envia para a AWS
    firehose.put_record(
        DeliveryStreamName=STREAM_NAME,
        Record={'Data': record}
    )
    
    print(f"Enviado: {payload['device_id']} | Temp: {payload['temperatura']}°C")
    time.sleep(1) # Intervalo de 1 segundo