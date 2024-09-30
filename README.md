# devsecops
Latam
Nicolas Linares Patiño
Tel: +573057864514
Email: ing.nicolas.linares@gmail.com

## Parte 1: Infraestructura e IaC

1. Para la primera parte, se eligió utilizar Cloud Run en GCP, creando dos funciones: una para leer y otra para escribir datos. Estas funciones exponen un endpoint HTTP que permite realizar peticiones. La selección de la base de datos fue un desafío; inicialmente consideré una base de datos NoSQL, pero al necesitar realizar analítica de datos, se optó por crear datasets en BigQuery y una tabla que se conecta con las funciones serverless. Así, el endpoint HTTP permite servir datos mediante métodos GET e ingresar datos con métodos POST.

Acontinuacion podemos ver los endpoints funcionales para realizar las peticiones con ```curl```

**function_write:**

```bash
curl -X POST https://us-central1-grounded-primer-436816-b5.cloudfunctions.net/write_function \
-H "Content-Type: application/json" \
-d '{
    "name": "Test Name",       
    "flight": "AA123",
    "date": "2024-09-30"
}'
```
**function_read:**
```bash
curl -X GET https://us-central1-grounded-primer-436816-b5.cloudfunctions.net/read_function

```
**Test:**

![Test en una terminal del write y read](images/1.png)


2. 