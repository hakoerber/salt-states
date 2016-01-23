{% from 'states/nagios/map.jinja' import nagios as nagios_map with context %}

graphios:
  pkg.installed:
    - name: {{ nagios_map.graphios.package }}
    - require:
      - pkg: nagios

  service.running:
    - name: {{ nagios_map.graphios.service }}
    - enable: true
    - require:
      - pkg: graphios
