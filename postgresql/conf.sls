#!stateconf
{% from 'states/postgresql/map.jinja' import postgresql as postgresql_map with context %}

.params:
    stateconf.set: []
# --- end of state config ---

postgresql.conf:
  file.managed:
    - name: {{ postgresql_map.dbroot + postgresql_map.conf }}
    - user: {{ postgresql_map.user }}
    - group: {{ postgresql_map.group }}
    - mode: 600
    - source: salt://states/postgresql/files/postgresql.conf.jinja
    - template: jinja
    - defaults:
        public: {{ params.public }}
    - require:
      - cmd: postgresql-default-initdb
    - watch_in:
      - service: postgresql
