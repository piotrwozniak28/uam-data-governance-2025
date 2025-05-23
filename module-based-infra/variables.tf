variable "gcp_project_id" {
  description = "The desired ID for the GCP project."
  type        = string
  # No default here, will be set in terraform.tfvars
}

variable "org_id" {
  description = "The organization ID to create the project under. e.g. '123456789012'"
  type        = string
  # No default here, will be set in terraform.tfvars
}

variable "folder_id" {
  description = "Optional. The folder ID to create the project under (e.g., 'folders/123456789012'). If org_id is also set, the project factory module might prioritize folder_id or have specific behavior."
  type        = string
  default     = null
}

variable "billing_account_id" {
  description = "The billing account ID to associate with the project. e.g. '012345-6789AB-CDEF01'"
  type        = string
  # No default here, will be set in terraform.tfvars
}

variable "dataset_names" {
  description = "A list of BigQuery dataset names to create."
  type        = list(string)
  default = [
    "bqd_rls_100_source_data",
    "bqd_rls_200_authorized_views",
    "bqd_rls_300_rap_basic",
    "bqd_rls_400_rap_lookup_no_hash",
    "bqd_rls_500_rap_lookup_hash"
  ]
}

variable "default_region" {
  description = "Default region for resources."
  type        = string
  default     = "us-central1"
}

variable "default_bq_location" {
  description = "Default location for BigQuery datasets (e.g., US, EU, asia-northeast1)."
  type        = string
  default     = "US"
}
