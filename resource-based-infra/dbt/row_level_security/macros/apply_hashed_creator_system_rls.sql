{% macro apply_hashed_creator_system_rls(
    target_relation,
    hashed_lookup_relation,
    filter_column_name,
    salt_variable_name
) %}
  {#- /*
      Applies a standard Row Access Policy to the target_relation based on a hashed lookup table.
      This policy filters rows for general authenticated users based on the hashed lookup data.
      Admin access should be handled by a separate TRUE filter policy.

      Args:
          target_relation: The relation object (table) to apply the policy to (e.g., `this`).
          hashed_lookup_relation: The relation object for the HASHED lookup table (e.g., `ref('hashed_lookup')`).
          filter_column_name: STRING name of the column in `target_relation` to filter on (e.g., 'creator_system_id').
          salt_variable_name: STRING name of the dbt variable containing the secret salt (e.g., 'rls_salt').

      Prerequisites:
        1. A dbt variable named `salt_variable_name` MUST be defined.
        2. A hashed lookup table (`hashed_lookup_relation`) MUST exist with correct columns.
  */ -#}

  {% set salt = var(salt_variable_name, none) %} -- Get the salt, default to None if not found

  {% if salt is none %}
    {{ exceptions.raise_compiler_error(
        "dbt variable '" ~ salt_variable_name ~ "' is not defined. " ~
        "This variable is required for the apply_hashed_creator_system_rls macro."
        )
    }}
  {% endif %}

  {% set policy_name = 'rls_hashed_lookup_' ~ filter_column_name ~ '_standard_access' %} {#- Define policy name dynamically -#}

  CREATE OR REPLACE ROW ACCESS POLICY {{ policy_name }}
  ON {{ target_relation }}
  GRANT TO ("allAuthenticatedUsers") {#- Grant broadly; filter does the work for non-admins -#}
  FILTER USING (
    -- Compare the hash generated from the target table row's data + session user + salt
    -- with the pre-calculated hashes in the lookup table.
    to_base64(sha256(concat(cast({{ filter_column_name }} as string), lower(session_user()), '{{ salt }}')))
    IN (
      SELECT
        permission_attribute_user_salted_hash -- The pre-hashed value in the lookup table
      FROM
        {{ hashed_lookup_relation }} -- The hashed lookup table
      WHERE
        -- Find the rows in the lookup table matching the hashed session user
        user_email_salted_hashed = to_base64(sha256(concat(lower(session_user()), '{{ salt }}')))
    )
  );

{% endmacro %}