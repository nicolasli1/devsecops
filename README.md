# devsecops
Latam

## Parte 1: Infraestructura e IaC

Para la primera parte, se eligió utilizar Cloud Run en GCP, creando dos funciones: una para leer y otra para escribir datos. Estas funciones exponen un endpoint HTTP que permite realizar peticiones. La selección de la base de datos fue un desafío; inicialmente consideré una base de datos NoSQL, pero al necesitar realizar analítica de datos, se optó por crear datasets en BigQuery y una tabla que se conecta con las funciones serverless. Así, el endpoint HTTP permite servir datos mediante métodos GET e ingresar datos con métodos POST.
