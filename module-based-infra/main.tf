# 1. Create the GCP Project using the Project Factory module
module "project_factory" {
  source  = "terraform-google-modules/project-factory/google"
  version = "18.0.0"

  name              = var.gcp_project_id
  random_project_id = false
  org_id            = var.org_id # Explicitly set the organization
  # folder_id         = var.folder_id # If set, project_factory usually prefers folder_id if both are set
  billing_account = var.billing_account_id
  # default_service_account     = "deprivileged"
  disable_services_on_destroy = false

  activate_apis = [
    "bigquery.googleapis.com",
  ]

  labels = {
    environment = "data-platform"
    managed-by  = "terraform-module"
  }

  auto_create_network = false
}

# 2. Create BigQuery Datasets using the BigQuery module
# We will create one module instance for each dataset name.
module "bigquery_datasets" {
  for_each = toset(var.dataset_names) # Iterate over each dataset name

  source  = "terraform-google-modules/bigquery/google"
  version = "10.1.0"

  project_id  = module.project_factory.project_id
  dataset_id  = each.value
  location    = var.default_bq_location
  description = "Dataset ${each.value} managed by Terraform BigQuery module"

  dataset_labels = {
    environment = "data-platform"
    managed-by  = "terraform-module"
    dataset     = each.value
  }
}
