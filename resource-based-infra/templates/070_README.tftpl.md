# Terraform templates_outputs
```bash
# 1. Use 'templates_outputs/020_tpc_ds.tmp.sh' to:
# - Generate TPC-DS data on VM
# - Copy TPC-DS data from VM to GCS

# 2. Use '030_tpc_ds_load_native_noauto.tmp.sh' to load TPC-DS data from GCS to BQ

# 3. Run TPC-DS sanity checks on BQ:
# - 040_row_counts_1_gb_meta.tmp.sql
# - 050_row_counts_1_gb.tmp.sql

# 4. create data profile for the 'customer' table

# 5. create data quality checks (based on data profile); edit selected check to make a quality test fail
```

# dbt CLS + Lineage

```bash
cd "$${HOME}/uam-data-governance-2025/resource-based-infra/dbt/row_level_security"

# 1. activate python venv, instal requirements
python3 -m venv .venv
. .venv/bin/activate
python -m pip --upgrade pip
python -m pip install -r requirements.txt

# 2. install dbt dependencies, verify config, run first models
dbt deps
dbt debug
dbt run --select='bqd_tpcds*' # Even the 'Owner' role isn't enough to view masked data - thus the roles/datacatalog.categoryFineGrainedReader is being granted tp {current_user_email} at project scope

# 3. review applied policy tags and their Data Masking Rules, view data as the {dwh_client_email}, apply/destroy policy tags using dbt
# 4. view auto-created Data Lineage at BQ level for query34

```

# dbt RLS

```bash
dbt seed
dbt run --select='bqd_rls*'
```

## 200 

`bqd_rls_200_authorized_views` can only be presented using {dwh_client_email}

```js
// 1. add this iam binding (add to main.tf or a separate .tf file) and try to query the view
resource "google_bigquery_dataset_iam_member" "dataset_reader_1" {
  project = google_project.this.project_id
  dataset_id = [
    for dataset_id in var.bq_dataset_names : dataset_id
    if can(regex(".*bqd_rls_200_authorized_views.*", dataset_id))
  ][0]
  role   = "roles/bigquery.dataViewer"
  member = "user:${dwh_client_email}"

  depends_on = [
    google_bigquery_dataset.this
  ]
}

// 2. authorize view at dataset level (add to main.tf or a separate .tf file); try to modify view's query

resource "google_bigquery_dataset_access" "access" {
  project    = google_project.this.project_id
  dataset_id = "bqd_rls_100_source_data"
  view {
    project_id = google_project.this.project_id
    dataset_id = "bqd_rls_200_authorized_views"
    table_id   = "v1"
  }
}
```

## >=300

```js
// 1. grant {dwh_user} "roles/bigquery.dataViewer" at project scope

resource "google_project_iam_member" "data_viewer" {
  project = google_project.this.project_id
  role    = "roles/bigquery.dataViewer"
  member  = "user:${dwh_client_email}"
}

```

```sql
-- query `prj-tpcds-ipbc6.bqd_rls_300_rap_basic.balances_copy_basic`
-- CREATE RAPs
-- Notice the difference before/after for both ${current_user_email} and ${dwh_client_email}

CREATE OR REPLACE ROW ACCESS POLICY creator_system_id_100
ON `${project_id}.bqd_rls_300_rap_basic.balances_copy_basic`
GRANT TO ('user:${current_user_email}')
FILTER USING (creator_system_id = 100);

CREATE OR REPLACE ROW ACCESS POLICY creator_system_id_200
ON `${project_id}.bqd_rls_300_rap_basic.balances_copy_basic`
GRANT TO ('user:${current_user_email}')
FILTER USING (creator_system_id = 200);

CREATE OR REPLACE ROW ACCESS POLICY creator_system_id_300
ON `${project_id}.bqd_rls_300_rap_basic.balances_copy_basic`
GRANT TO ('user:${current_user_email}')
FILTER USING (creator_system_id = 300);

CREATE OR REPLACE ROW ACCESS POLICY all_access
ON `${project_id}.bqd_rls_300_rap_basic.balances_copy_basic`
GRANT TO ('user:${current_user_email}')
FILTER USING (TRUE);

-- DROP RAP

DROP ROW ACCESS POLICY all_access ON `${project_id}.bqd_rls_300_rap_basic.balances_copy_basic`;

DROP ALL ROW ACCESS POLICIES ON `${project_id}.bqd_rls_300_rap_basic.balances_copy_basic`;

-- SELECT

SELECT * FROM `${project_id}.bqd_rls_300_rap_basic.balances_copy_basic`;

-- INSERT

INSERT INTO `${project_id}.bqd_rls_300_rap_basic.balances_copy_basic` (
    balance_id,
    balance_target,
    balance_status,
    creator_system_id
)
VALUES
    (999, 'XXX', 'XXX', 999);
```
