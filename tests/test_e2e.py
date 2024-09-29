import requests
import json
import time

# URL de las funciones
read_function_url = "https://us-central1-grounded-primer-436816-b5.cloudfunctions.net/read_function"
write_function_url = "https://us-central1-grounded-primer-436816-b5.cloudfunctions.net/write_function"

# Datos a insertar
data_to_insert = {
    "name": "Patricia Patino",
    "flight": "AA123",
    "date": "2024-09-27"
}

# Hacer una petición POST para insertar datos
response = requests.post(write_function_url, json=data_to_insert)

if response.status_code == 200:
    print("Data inserted successfully:", response.text)
else:
    print("Failed to insert data:", response.text)

# Esperar un momento para asegurarse de que los datos se insertan correctamente
time.sleep(2)

# Hacer una petición GET para leer los datos
response = requests.get(read_function_url)

if response.status_code == 200:
    data = response.json().get('data', [])
    print("Data retrieved successfully:", json.dumps(data, indent=2))

    # Verificar que los datos insertados están presentes
    assert any(item['name'] == "Patricia Patino" for item in data), "Inserted data not found in retrieved data"
else:
    print("Failed to retrieve data:", response.text)
