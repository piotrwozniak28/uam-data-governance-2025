{% macro apply_admin_rls_true_filter(
    target_relation,
    admin_principals_variable_name='rls_admin_principals'
) %}
  {#-
      /*
      Applies a Row Access Policy with FILTER USING (TRUE) to grant full access
      to specified admin principals.

      Args:
          target_relation: The relation object (table) to apply the policy to (e.g., `this`).
          admin_principals_variable_name: STRING name of the dbt variable containing the
                                          list of admin principals (users, groups, service accounts).
                                          Defaults to 'rls_admin_principals'.
      */
  -#}

  {% set admin_principals = var(admin_principals_variable_name, []) %} {#- Get admin list, default to empty list -#}

  {% if admin_principals | length > 0 %} {#- Only create the policy if admins are defined -#}

    {% set policy_name = 'rls_admin_true_filter_access' %} {#- Define admin policy name -#}

    CREATE OR REPLACE ROW ACCESS POLICY {{ policy_name }}
    ON {{ target_relation }}
    GRANT TO (
        {%- for principal in admin_principals -%}
        '{{ principal }}' {{- ", " if not loop.last else "" -}}
        {%- endfor -%}
    )
    FILTER USING (TRUE);

    {{ log("Applied TRUE filter admin policy '" ~ policy_name ~ "' for " ~ admin_principals|length ~ " principal(s) on " ~ target_relation, info=True) }}

  {% else %}
    {{ log("No admin principals found in var('" ~ admin_principals_variable_name ~ "'). Skipping TRUE filter policy creation for " ~ target_relation, info=True) }}
  {% endif %}

{% endmacro %}