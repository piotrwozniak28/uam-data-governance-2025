-- query34
SELECT c_last_name,
       c_first_name,
       c_salutation,
       c_preferred_cust_flag,
       ss_ticket_number,
       cnt
FROM   (SELECT ss_ticket_number,
               ss_customer_sk,
               Count(*) cnt
        FROM   `${project_id}.${bigquery_dataset_id}.store_sales`,
               `${project_id}.${bigquery_dataset_id}.date_dim`,
               `${project_id}.${bigquery_dataset_id}.store`,
               `${project_id}.${bigquery_dataset_id}.household_demographics`
        WHERE  `${project_id}.${bigquery_dataset_id}.store_sales`.ss_sold_date_sk = `${project_id}.${bigquery_dataset_id}.date_dim`.d_date_sk
               AND `${project_id}.${bigquery_dataset_id}.store_sales`.ss_store_sk = `${project_id}.${bigquery_dataset_id}.store`.s_store_sk
               AND `${project_id}.${bigquery_dataset_id}.store_sales`.ss_hdemo_sk = `${project_id}.${bigquery_dataset_id}.household_demographics`.hd_demo_sk
               AND ( `${project_id}.${bigquery_dataset_id}.date_dim`.d_dom BETWEEN 1 AND 3
                      OR `${project_id}.${bigquery_dataset_id}.date_dim`.d_dom BETWEEN 25 AND 28 )
               AND ( `${project_id}.${bigquery_dataset_id}.household_demographics`.hd_buy_potential = '>10000'
                      OR `${project_id}.${bigquery_dataset_id}.household_demographics`.hd_buy_potential = 'unknown' )
               AND `${project_id}.${bigquery_dataset_id}.household_demographics`.hd_vehicle_count > 0
               AND ( CASE
                       WHEN `${project_id}.${bigquery_dataset_id}.household_demographics`.hd_vehicle_count > 0 THEN
                       `${project_id}.${bigquery_dataset_id}.household_demographics`.hd_dep_count /
                       `${project_id}.${bigquery_dataset_id}.household_demographics`.hd_vehicle_count
                       ELSE NULL
                     END ) > 1.2
               AND `${project_id}.${bigquery_dataset_id}.date_dim`.d_year IN ( 1999, 1999 + 1, 1999 + 2 )
               AND `${project_id}.${bigquery_dataset_id}.store`.s_county IN ( 'Williamson County', 'Williamson County',
                                       'Williamson County',
                                                             'Williamson County'
                                       ,
                                       'Williamson County', 'Williamson County',
                                           'Williamson County',
                                                             'Williamson County'
                                     )
        GROUP  BY ss_ticket_number,
                  ss_customer_sk) dn,
       `${project_id}.${bigquery_dataset_id}.customer`
WHERE  ss_customer_sk = c_customer_sk
       AND cnt BETWEEN 15 AND 20
ORDER  BY c_last_name,
          c_first_name,
          c_salutation,
          c_preferred_cust_flag DESC,
          ss_ticket_number
;
