import os
import pytest
from unittest.mock import patch, MagicMock
from backend.func2.main import hello_http

@pytest.fixture
def fake_request():
    class Request:
        def __init__(self, json_data):
            self._json = json_data

        def get_json(self, silent=False):
            return self._json

    return Request

@patch('google.cloud.bigquery.Client')
def test_hello_http(mock_bigquery_client, fake_request):
    # Configura el entorno
    os.environ['DATASET_ID'] = 'test_dataset'
    os.environ['TABLE_ID'] = 'test_table'

    mock_client = MagicMock()
    mock_bigquery_client.return_value = mock_client

    # Simula el conteo de filas
    mock_client.query.return_value.result.return_value = [MagicMock(total=1)]

    # Simula la inserción de filas
    mock_client.insert_rows_json.return_value = []

    request_data = {
        "name": "Test User",
        "flight": "Test Flight",
        "date": "2024-09-27"
    }

    request = fake_request(json_data=request_data)
    response = hello_http(request)

    assert response[1] == 200
    assert 'Data inserted' in response[0]
