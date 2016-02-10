{% from 'states/kibana/map.jinja' import kibana as kibana_map with context %}

kibana:
  pkg.installed:
    - pkgs: {{ kibana_map.packages }}

  service.running:
    - name: {{ kibana_map.service }}
    - enable: true
    - require:
      - pkg: kibana
