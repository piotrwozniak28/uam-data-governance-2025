variable "billing_account_id" {
  description = "The billing account ID to associate with the project. e.g. '012345-6789AB-CDEF01'"
  type        = string
}

variable "org_id" {
  description = "The organization ID to create the project under. e.g. '123456789012'"
  type        = string
  default     = null
}

variable "folder_id" {
  description = "The folder ID to create the project under. e.g. 'folders/123456789012'. Takes precedence over org_id if both are set for project factory module."
  type        = string
  default     = null
}

variable "region" {
  description = "Default region for resources."
  type        = string
}

variable "bq_dataset_names" {
  description = "A list of BigQuery dataset names to create."
  type        = list(string)
  default     = []
}

variable "current_user_email" {
  type        = string
}

variable "dwh_client_email" {
  type        = string
  default     = null
}