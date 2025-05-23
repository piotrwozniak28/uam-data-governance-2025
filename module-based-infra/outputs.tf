output "project_id" {
  description = "The ID of the created GCP project."
  value       = module.project_factory.project_id
}

output "project_number" {
  description = "The number of the created GCP project."
  value       = module.project_factory.project_number
}

output "created_bigquery_dataset_ids" {
  description = "A list of created BigQuery dataset IDs."
  value       = [for ds_instance in module.bigquery_datasets : ds_instance.bigquery_dataset.dataset_id]
}

output "created_bigquery_datasets_details" {
  description = "A map of created BigQuery datasets, where keys are dataset names and values are the full module outputs for each dataset."
  value       = module.bigquery_datasets
  sensitive   = true
}
