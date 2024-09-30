import os
from google.cloud import bigquery
import functions_framework

@functions_framework.http
def hello_http(request):
    client = bigquery.Client()
    dataset_id = os.environ.get('DATASET_ID')
    table_id = os.environ.get('TABLE_ID')

    # Consulta simple para obtener todos los datos
    query = f'SELECT * FROM `{dataset_id}.{table_id}`'

    try:
        results = client.query(query).result()
        rows = [dict(row) for row in results]
        return {'data': rows}, 200
    except Exception as e:
        return {'error': str(e)}, 500