{{ config(materialized='view') }}

with source_data as (
    select * from {{ ref('balances') }}
    where balance_target = "AAA"
)

select * from source_data
