output "project_id" {
  description = "The ID of the created GCP project."
  value       = "prj-tpcds-${random_string.this.result}"
}

output "bigquery_dataset_ids" {
  description = "A list of created BigQuery dataset IDs."
  value       = [for k in google_bigquery_dataset.this : k.dataset_id]
}

output "z_helper_urls" {
  value = {
    "vms": "https://console.cloud.google.com/compute/instances?project=${google_project.this.project_id}",
    "bq": "https://console.cloud.google.com/bigquery?project=${google_project.this.project_id}",
    "gcs": "https://console.cloud.google.com/storage/browser?project=${google_project.this.project_id}",
    "taxonomies": "https://console.cloud.google.com/bigquery/policy-tags/locations/${var.region}/taxonomies/${basename(google_data_catalog_taxonomy.this.id)};container=${google_project.this.project_id}",
  }
}
