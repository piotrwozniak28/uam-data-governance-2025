-- models/intermediate/int_rls_hashed_lookup.sql

{% set salt = var('rls_salt') %} -- Get the salt from dbt variables

-- Check if the salt variable is defined
{% if salt is none %}
  {{ exceptions.raise_compiler_error("dbt variable 'rls_salt' is not defined. Please define it in dbt_project.yml or via --vars/environment variables for RLS hashing.") }}
{% endif %}


with raw_data as (

    select * from {{ ref('lookup_table_data_hash') }} -- Reference the RAW seed file

),

hashed_data as (

    select
        -- TO_BASE64(SHA256(CONCAT(user_email, 'HARDCODED_SALT')))
        to_base64(sha256(concat(lower(user_email), '{{ salt }}'))) as user_email_salted_hashed,

        -- TO_BASE64(SHA256(CONCAT(allowed_creator_system_id, user_email, 'HARDCODED_SALT')))
        -- Important: Cast ID to STRING for concatenation
        to_base64(sha256(concat(cast(allowed_creator_system_id as string), lower(user_email), '{{ salt }}'))) as permission_attribute_user_salted_hash

    from raw_data
)

select * from hashed_data
