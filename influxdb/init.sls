{% from 'states/influxdb/map.jinja' import influxdb as influxdb_map with context %}

influxdb:
  pkg.installed:
    - name: {{ influxdb_map.package }}

  service.running:
    - name: {{ influxdb_map.service }}
    - enable: true
    - require:
      - pkg: influxdb
