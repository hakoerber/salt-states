#!stateconf
{% from 'states/postgresql/map.jinja' import postgresql as postgresql_map with context %}

.params:
    stateconf.set: []
# --- end of state config ---

{% for db in params.databases %}
postgresql-database-{{ db.name }}:
  postgres_database.present:
    - name: {{ db.name }}
    - owner: {{ db.owner }}
    - require:
      - postgres_user: {{ db.owner }}
{% endfor %}
