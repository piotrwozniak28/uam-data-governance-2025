resource "google_data_catalog_taxonomy" "this" {
  depends_on = [
    time_sleep.wait_30_seconds
  ]  
  project                = google_project.this.project_id
  region                 = var.region
  display_name           = "tax-tpcds-${random_string.this.result}"
  description            = "A collection of policy tags"
  activated_policy_types = ["FINE_GRAINED_ACCESS_CONTROL"]
}

resource "google_data_catalog_policy_tag" "this" {
  taxonomy     = google_data_catalog_taxonomy.this.id
  display_name = "PII_Data"
  description  = "Policy tag for Personally Identifiable Information (PII) that requires controlled access"
}

resource "google_bigquery_datapolicy_data_policy" "this" {
  project          = google_project.this.project_id
  location         = var.region
  data_policy_id   = "bq_data_policy_pii"
  policy_tag       = google_data_catalog_policy_tag.this.id
  data_policy_type = "DATA_MASKING_POLICY"
  data_masking_policy {
    predefined_expression = "SHA256"
  }
}

resource "google_bigquery_datapolicy_data_policy_iam_member" "member" {
  project        = google_project.this.project_id
  location       = google_bigquery_datapolicy_data_policy.this.location
  data_policy_id = google_bigquery_datapolicy_data_policy.this.data_policy_id
  role           = "roles/bigquerydatapolicy.maskedReader"
  member         = "user:gftdummyuser100@customcloudsolutions.pl"
}

resource "google_data_catalog_policy_tag" "email" {
  taxonomy     = google_data_catalog_taxonomy.this.id
  display_name = "EMAIL"
  description  = "Policy tag for email addresses that requires controlled access"
}

resource "google_bigquery_datapolicy_data_policy" "email" {
  project          = google_project.this.project_id
  location         = var.region
  data_policy_id   = "bq_data_policy_email"
  policy_tag       = google_data_catalog_policy_tag.email.id
  data_policy_type = "DATA_MASKING_POLICY"
  data_masking_policy {
    predefined_expression = "EMAIL_MASK"
  }
}

resource "google_bigquery_datapolicy_data_policy_iam_member" "email" {
  project        = google_project.this.project_id
  location       = google_bigquery_datapolicy_data_policy.email.location
  data_policy_id = google_bigquery_datapolicy_data_policy.email.data_policy_id
  role           = "roles/bigquerydatapolicy.maskedReader"
  member         = "user:gftdummyuser100@customcloudsolutions.pl"
}
