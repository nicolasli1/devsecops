import os
import functions_framework
from google.cloud import bigquery

@functions_framework.http
def hello_http(request):
    """HTTP Cloud Function."""
    client = bigquery.Client()
    dataset_id = os.environ.get('DATASET_ID')
    table_id = os.environ.get('TABLE_ID')


    request_json = request.get_json(silent=True)

    if request_json and 'name' in request_json and 'flight' in request_json and 'date' in request_json:
        name = request_json['name']
        flight = request_json['flight']
        date = request_json['date']

        # Realiza la consulta y obtiene el conteo directamente
        query = f'SELECT COUNT(*) as total FROM `{dataset_id}.{table_id}`'
        query_job = client.query(query)
        row_count = [row.total for row in query_job.result()][0]

        row_to_insert = [{
            "id": str(row_count + 1),  # Generar ID automáticamente
            "name": name,
            "flight": flight,
            "date": date
        }]

        try:
            errors = client.insert_rows_json(f'{dataset_id}.{table_id}', row_to_insert)
            if errors:
                return f'Error inserting row: {errors}', 500
            return f'Data inserted: {row_to_insert}', 200
        except Exception as e:
            return f'An error occurred: {str(e)}', 500

    return 'Invalid request, please provide name, flight, and date.', 400
