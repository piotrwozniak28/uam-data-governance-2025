{{
  config(
    materialized='table'
  )
}}

with cte as (
	select {{ dbt_utils.star(from=ref('query34')) }}, 
  `c_first_name` || "." || `c_last_name` || "@gmail.com" AS email
  from {{ ref('query34') }}

)
select * from cte