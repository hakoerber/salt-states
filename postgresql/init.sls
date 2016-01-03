#!stateconf
{% from 'states/postgresql/map.jinja' import postgresql as postgresql_map with context %}

postgresql:
  pkg.installed:
    - name: {{ postgresql_map.package }}

  service.running:
    - name: {{ postgresql_map.service }}
    - enable: true
    - require:
      - pkg: postgresql
