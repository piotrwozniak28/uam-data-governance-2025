{% macro apply_creator_system_rls(
    target_relation,
    lookup_relation,
    filter_column_name,
    lookup_user_column='user_email',
    lookup_permission_column='allowed_creator_system_id'
) %}
  {#-
      /*
      Applies a standard Row Access Policy to the target_relation based on a lookup table.
      This policy filters rows for general authenticated users based on the lookup data.
      Admin access should be handled by a separate TRUE filter policy.

      Args:
          target_relation: The relation object (table) to apply the policy to (e.g., `this`).
          lookup_relation: The relation object for the lookup table (e.g., `ref('lookup_table_data_no_hash')`).
          filter_column_name: STRING name of the column in `target_relation` to filter on (e.g., 'creator_system_id').
          lookup_user_column: STRING name of the column in `lookup_relation` containing the user principal (e.g., 'user_email'). Defaults to 'user_email'.
          lookup_permission_column: STRING name of the column in `lookup_relation` containing the allowed attribute value (e.g., 'allowed_creator_system_id'). Defaults to 'allowed_creator_system_id'.
      */
  -#}

  {% set policy_name = 'rls_lookup_' ~ filter_column_name ~ '_standard_access' %} {#- Define policy name -#}

  CREATE OR REPLACE ROW ACCESS POLICY {{ policy_name }}
  ON {{ target_relation }}
  {#- Grant broadly - the filter does the real work based on SESSION_USER() for non-admins -#}
  GRANT TO ("allAuthenticatedUsers")
  FILTER USING (
    {{ filter_column_name }} IN (
      SELECT {{ lookup_permission_column }}
      FROM {{ lookup_relation }}
      WHERE lower({{ lookup_user_column }}) = lower(SESSION_USER())
    )
  );

{% endmacro %}