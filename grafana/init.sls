{% from 'states/grafana/map.jinja' import grafana as grafana_map with context %}

grafana:
  pkg.installed:
    - name: {{ grafana_map.package }}

  service.running:
    - name: {{ grafana_map.service }}
    - enable: true
    - require:
      - pkg: grafana
