with source_data as (
    select * from {{ ref('balances') }}
)

select * from source_data
