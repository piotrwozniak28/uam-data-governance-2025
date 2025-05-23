{{
  config(
    materialized='table'
  )
}}

with frequent_shoppers as (
  select
    ss.ss_ticket_number,
    ss.ss_customer_sk,
    count(*) as cnt
  from
    {{ source('tpcds_raw', 'store_sales') }} as ss
  join
    {{ source('tpcds_raw', 'date_dim') }} as dd on ss.ss_sold_date_sk = dd.d_date_sk
  join
    {{ source('tpcds_raw', 'store') }} as s on ss.ss_store_sk = s.s_store_sk
  join
    {{ source('tpcds_raw', 'household_demographics') }} as hd on ss.ss_hdemo_sk = hd.hd_demo_sk
  where
    (dd.d_dom between 1 and 3 or dd.d_dom between 25 and 28)
    and (hd.hd_buy_potential = '>10000' or hd.hd_buy_potential = 'unknown')
    and hd.hd_vehicle_count > 0
    and (
      case
        when hd.hd_vehicle_count > 0 then (hd.hd_dep_count * 1.0 / hd.hd_vehicle_count) -- ensure float division
        else null
      end
    ) > 1.2
    and dd.d_year in (1999, 1999 + 1, 1999 + 2)
    and s.s_county in (
      'Williamson County', 'Williamson County', 'Williamson County', 'Williamson County',
      'Williamson County', 'Williamson County', 'Williamson County', 'Williamson County'
    )
  group by
    ss.ss_ticket_number,
    ss.ss_customer_sk
)

select
  c.c_last_name,
  c.c_first_name,
  c.c_salutation,
  c.c_preferred_cust_flag,
  fs.ss_ticket_number,
  fs.cnt
from
  frequent_shoppers as fs
join
  {{ source('tpcds_raw', 'customer') }} as c on fs.ss_customer_sk = c.c_customer_sk
where
  fs.cnt between 15 and 20
order by
  c.c_last_name,
  c.c_first_name,
  c.c_salutation,
  c.c_preferred_cust_flag desc,
  fs.ss_ticket_number