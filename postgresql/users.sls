#!stateconf
{% from 'states/postgresql/map.jinja' import postgresql as postgresql_map with context %}

.params:
    stateconf.set: []
# --- end of state config ---

{% for user in params.users %}
postgresql-user-{{ user.name }}:
  postgres_user.present:
    - name: {{ user.name }}
    - createdb: {{ user.can_create_db }}
    - createroles: {{ user.can_create_roles }}
    - superuser: {{ user.is_superuser }}
    - password: {{ user.password }}
{% endfor %}

