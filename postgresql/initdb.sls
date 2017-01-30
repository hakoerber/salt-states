#!stateconf
{% from 'states/postgresql/map.jinja' import postgresql as postgresql_map with context %}

postgresql-default-initdb:
  cmd.run:
    - name: postgresql-setup initdb
    - user: root
    - env:
      - PGSETUP_INITDB_OPTIONS: >
          "--locale={{ postgresql_map.locale }}"
          "--encoding={{ postgresql_map.encoding }}"
          "--username={{ postgresql_map.adminuser }}"
    - unless:
      - postgresql-check-db-dir {{ postgresql_map.dbroot }}
    - require_in:
      - service: postgresql
