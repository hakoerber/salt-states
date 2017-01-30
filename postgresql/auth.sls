#!stateconf
{% from 'states/postgresql/map.jinja' import postgresql as postgresql_map with context %}

.params:
    stateconf.set: []
# --- end of state config ---

postgresql-hba.conf:
  file.managed:
    - name: {{ postgresql_map.dbroot + postgresql_map.hba_conf }}
    - user: {{ postgresql_map.user }}
    - group: {{ postgresql_map.group }}
    - mode: 600
    - source: salt://states/postgresql/files/pg_hba.conf.jinja
    - defaults:
        auth: {{ params.auth }}
    - template: jinja
    - require:
      - cmd: postgresql-default-initdb
    - watch_in:
      - service: postgresql

postgresql-ident.conf:
  file.managed:
    - name: {{ postgresql_map.dbroot + postgresql_map.ident_conf }}
    - user: {{ postgresql_map.user }}
    - group: {{ postgresql_map.group }}
    - mode: 600
    - source: salt://states/postgresql/files/pg_ident.conf.jinja
    - defaults:
        auth: {{ params.auth }}
    - template: jinja
    - require:
      - cmd: postgresql-default-initdb
    - watch_in:
      - service: postgresql
