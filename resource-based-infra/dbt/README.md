# 200

https://cloud.google.com/bigquery/docs/reference/standard-sql/data-definition-language#create_row_access_policy_statement

```sql
-- CREATE RAP

CREATE OR REPLACE ROW ACCESS POLICY creator_system_id_100
ON `prj-dev-dbt-aol.bqd_rls_300_rap_basic.balances_copy_basic`
GRANT TO ('user:e-prwk@gft.com')
FILTER USING (creator_system_id = 100);

CREATE OR REPLACE ROW ACCESS POLICY creator_system_id_200
ON `prj-dev-dbt-aol.bqd_rls_300_rap_basic.balances_copy_basic`
GRANT TO ('user:e-prwk@gft.com')
FILTER USING (creator_system_id = 200);

CREATE OR REPLACE ROW ACCESS POLICY creator_system_id_300
ON `prj-dev-dbt-aol.bqd_rls_300_rap_basic.balances_copy_basic`
GRANT TO ('user:e-prwk@gft.com')
FILTER USING (creator_system_id = 300);

CREATE OR REPLACE ROW ACCESS POLICY all_access
ON `prj-dev-dbt-aol.bqd_rls_300_rap_basic.balances_copy_basic`
GRANT TO ('user:e-prwk@gft.com')
FILTER USING (TRUE);

-- DROP RAP

DROP ROW ACCESS POLICY all_access ON `prj-dev-dbt-aol.bqd_rls_300_rap_basic.balances_copy_basic`;

DROP ALL ROW ACCESS POLICIES ON `prj-dev-dbt-aol.bqd_rls_300_rap_basic.balances_copy_basic`;

-- SELECT

SELECT * FROM `prj-dev-dbt-aol.bqd_rls_300_rap_basic.balances_copy_basic`;

-- INSERT

INSERT INTO `prj-dev-dbt-aol.bqd_rls_300_rap_basic.balances_copy_basic` (
    balance_id,
    balance_target,
    balance_status,
    creator_system_id
)
VALUES
    (999, 'XXX', 'XXX', 999);
```