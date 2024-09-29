output "bigquery_dataset_id" {
  description = "ID of the created BigQuery dataset"
  value       = google_bigquery_dataset.my_dataset.dataset_id
}

output "bigquery_table_id" {
  description = "ID of the created BigQuery table"
  value       = google_bigquery_table.my_table.table_id
}

output "bigquery_table_full_id" {
  description = "Full ID of the created BigQuery table"
  value       = "${google_bigquery_dataset.my_dataset.dataset_id}.${google_bigquery_table.my_table.table_id}"
}

output "write_function" {
  description = "URL of the deployed Cloud Function"
  value       = google_cloudfunctions_function.write_function.https_trigger_url
}

output "read_function" {
  description = "URL of the deployed Cloud Function"
  value       = google_cloudfunctions_function.read_function.https_trigger_url
}

output "bucket_name" {
  description = "Name of the Cloud Storage bucket"
  value       = google_storage_bucket.function_bucket.name
}

output "pubsub_topic" {
  description = "Pub/Sub topic name"
  value       = google_pubsub_topic.topic.name
}

