terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0" # Or your preferred version
    }
  }
}

provider "google" {
  # You can specify project and region here, but for project creation,
  # they are often set at the resource/module level or inferred.
  # project = var.gcp_project_id # Not needed for project creation itself
  # region  = var.default_region
}
