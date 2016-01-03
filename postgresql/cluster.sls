#!stateconf
{% from 'states/postgresql/map.jinja' import postgresql as postgresql_map with context %}

postgresql-default-cluster:
  cmd.run:
    - name: postgresql-setup initdb
    - user: root
    #- creates: {{ postgresql_map.dbroot }}
    - env:
      - PGSETUP_INITDB_OPTIONS: >
          "--locale={{ postgresql_map.locale }}"
          "--encoding={{ postgresql_map.encoding }}"
    - unless:
      - postgresql-check-db-dir {{ postgresql_map.dbroot }}
    - require_in:
      - service: postgresql
    #    - onchanges:
    #      - pkg: postgresql
    #      - service: postgresql
