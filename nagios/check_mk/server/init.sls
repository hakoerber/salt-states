{% from 'states/nagios/map.jinja' import nagios as nagios_map with context %}

check_mk-server:
  service.running:
    - name: {{ nagios_map.check_mk.server.service }}
    - enable: true
