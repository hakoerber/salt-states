{% from 'states/nagios/map.jinja' import nagios as nagios_map with context %}

check_mk-server:
  pkg.installed:
    - name: {{ nagios_map.check_mk.server.package }}
    - require:
      - pkg: nagios
