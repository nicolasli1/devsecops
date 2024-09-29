provider "google" {
  project = var.project
  region  = var.region
}


resource "google_bigquery_dataset" "my_dataset" {
  dataset_id = "Latam_dataset" # Cambia esto al ID deseado
  location   = "US"

  labels = {
    env = "dev"
  }
}

resource "google_bigquery_table" "my_table" {
  table_id            = "Flights-table"
  dataset_id          = google_bigquery_dataset.my_dataset.dataset_id
  project             = google_bigquery_dataset.my_dataset.project
  deletion_protection = false

  schema = <<EOF
  [
    {
      "name": "id",
      "type": "STRING",
      "mode": "REQUIRED"
    },
    {
      "name": "name",
      "type": "STRING",
      "mode": "NULLABLE"
    },
    {
      "name": "flight",
      "type": "STRING",
      "mode": "NULLABLE"
    },
    {
      "name": "date",
      "type": "DATE",
      "mode": "NULLABLE"
    }
  ]
  EOF
}


resource "google_storage_bucket" "function_bucket" {
  name     = "grounded-primer-436816-b5-functions"
  location = "US"
}

resource "google_storage_bucket_object" "function_read" {
  name   = "read-data.zip"
  bucket = google_storage_bucket.function_bucket.name
  source = "../code/func1/function-source.zip"
}

resource "google_storage_bucket_object" "function_write" {
  name   = "write-data.zip"
  bucket = google_storage_bucket.function_bucket.name
  source = "../code/func2/function-source.zip"
}


resource "google_cloudfunctions_function" "read_function" {
  name                  = "read_function"
  runtime               = "python310"
  entry_point           = "hello_http"
  source_archive_bucket = google_storage_bucket.function_bucket.name
  source_archive_object = google_storage_bucket_object.function_read.name
  trigger_http          = true
  available_memory_mb   = 256

  environment_variables = {
    DATASET_ID = google_bigquery_dataset.my_dataset.dataset_id
    TABLE_ID   = google_bigquery_table.my_table.table_id
  }
}

resource "google_cloudfunctions_function" "write_function" {
  name                  = "write_function"
  runtime               = "python310"
  entry_point           = "hello_http"
  source_archive_bucket = google_storage_bucket.function_bucket.name
  source_archive_object = google_storage_bucket_object.function_write.name
  trigger_http          = true
  available_memory_mb   = 256

  environment_variables = {
    DATASET_ID = google_bigquery_dataset.my_dataset.dataset_id
    TABLE_ID   = google_bigquery_table.my_table.table_id
  }
}

resource "google_cloudfunctions_function_iam_member" "write_function_invoker" {
  project        = google_cloudfunctions_function.write_function.project
  region         = google_cloudfunctions_function.write_function.region
  cloud_function = google_cloudfunctions_function.write_function.name
  role           = "roles/cloudfunctions.invoker"
  member         = "allUsers"
}

resource "google_cloudfunctions_function_iam_member" "read_function_invoker" {
  project        = google_cloudfunctions_function.read_function.project
  region         = google_cloudfunctions_function.read_function.region
  cloud_function = google_cloudfunctions_function.read_function.name
  role           = "roles/cloudfunctions.invoker"
  member         = "allUsers"
}


resource "google_pubsub_topic" "topic" {
  name = "topic-latam"
  labels = {
    foo = "bar"
  }

  message_retention_duration = "86600s"
}

resource "google_pubsub_subscription" "subscription-latam" {
  name  = "subscription-latam"
  topic = google_pubsub_topic.topic.id

  ack_deadline_seconds = 20

  # bigquery_config {
  #   table              = "${var.project}.${google_bigquery_dataset.my_dataset.dataset_id}.${google_bigquery_table.my_table.table_id}"
  #   use_table_schema   = true  # Si quieres usar el esquema de la tabla
  #   write_metadata     = true  # Si quieres agregar metadatos
  #   drop_unknown_fields = true  # Para evitar errores con campos desconocidos
  # }

  labels = {
    foo = "bar"
  }
}
