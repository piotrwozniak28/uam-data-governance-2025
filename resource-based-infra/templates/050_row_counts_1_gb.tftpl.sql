-- Reference values from "Table 3-2 Database Row Counts" (page 44):
-- https://www.tpc.org/TPC_Documents_Current_Versions/pdf/TPC-DS_v4.0.0.pdf

ASSERT (

WITH cte1 AS (

SELECT 'call_center'            AS table_name, COUNT(*) - 6        AS diff, FROM `${project_id}.${bigquery_dataset_id}.call_center`            UNION ALL
SELECT 'catalog_page'           AS table_name, COUNT(*) - 11718    AS diff, FROM `${project_id}.${bigquery_dataset_id}.catalog_page`           UNION ALL
SELECT 'catalog_returns'        AS table_name, COUNT(*) - 144067   AS diff, FROM `${project_id}.${bigquery_dataset_id}.catalog_returns`        UNION ALL
SELECT 'catalog_sales'          AS table_name, COUNT(*) - 1441548  AS diff, FROM `${project_id}.${bigquery_dataset_id}.catalog_sales`          UNION ALL
SELECT 'customer'               AS table_name, COUNT(*) - 100000   AS diff, FROM `${project_id}.${bigquery_dataset_id}.customer`               UNION ALL
SELECT 'customer_address'       AS table_name, COUNT(*) - 50000    AS diff, FROM `${project_id}.${bigquery_dataset_id}.customer_address`       UNION ALL
SELECT 'customer_demographics'  AS table_name, COUNT(*) - 1920800  AS diff, FROM `${project_id}.${bigquery_dataset_id}.customer_demographics`  UNION ALL
SELECT 'date_dim'               AS table_name, COUNT(*) - 73049    AS diff, FROM `${project_id}.${bigquery_dataset_id}.date_dim`               UNION ALL
SELECT 'household_demographics' AS table_name, COUNT(*) - 7200     AS diff, FROM `${project_id}.${bigquery_dataset_id}.household_demographics` UNION ALL
SELECT 'income_band'            AS table_name, COUNT(*) - 20       AS diff, FROM `${project_id}.${bigquery_dataset_id}.income_band`            UNION ALL
SELECT 'inventory'              AS table_name, COUNT(*) - 11745000 AS diff, FROM `${project_id}.${bigquery_dataset_id}.inventory`              UNION ALL
SELECT 'item'                   AS table_name, COUNT(*) - 18000    AS diff, FROM `${project_id}.${bigquery_dataset_id}.item`                   UNION ALL
SELECT 'promotion'              AS table_name, COUNT(*) - 300      AS diff, FROM `${project_id}.${bigquery_dataset_id}.promotion`              UNION ALL
SELECT 'reason'                 AS table_name, COUNT(*) - 75       AS diff, FROM `${project_id}.${bigquery_dataset_id}.reason`                 UNION ALL
SELECT 'ship_mode'              AS table_name, COUNT(*) - 20       AS diff, FROM `${project_id}.${bigquery_dataset_id}.ship_mode`              UNION ALL
SELECT 'store'                  AS table_name, COUNT(*) - 12       AS diff, FROM `${project_id}.${bigquery_dataset_id}.store`                  UNION ALL
SELECT 'store_returns'          AS table_name, COUNT(*) - 287514   AS diff, FROM `${project_id}.${bigquery_dataset_id}.store_returns`          UNION ALL
SELECT 'store_sales'            AS table_name, COUNT(*) - 2880404  AS diff, FROM `${project_id}.${bigquery_dataset_id}.store_sales`            UNION ALL
SELECT 'time_dim'               AS table_name, COUNT(*) - 86400    AS diff, FROM `${project_id}.${bigquery_dataset_id}.time_dim`               UNION ALL
SELECT 'warehouse'              AS table_name, COUNT(*) - 5        AS diff, FROM `${project_id}.${bigquery_dataset_id}.warehouse`              UNION ALL
SELECT 'web_page'               AS table_name, COUNT(*) - 60       AS diff, FROM `${project_id}.${bigquery_dataset_id}.web_page`               UNION ALL
SELECT 'web_returns'            AS table_name, COUNT(*) - 71763    AS diff, FROM `${project_id}.${bigquery_dataset_id}.web_returns`            UNION ALL
SELECT 'web_sales'              AS table_name, COUNT(*) - 719384   AS diff, FROM `${project_id}.${bigquery_dataset_id}.web_sales`              UNION ALL
SELECT 'web_site'               AS table_name, COUNT(*) - 30       AS diff  FROM `${project_id}.${bigquery_dataset_id}.web_site`

)

SELECT SUM(diff) FROM cte1) = 0 AS 'Row counts for TPC-DS tables must be the same as in the documentation';
