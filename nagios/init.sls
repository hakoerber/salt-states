{% from 'states/nagios/map.jinja' import nagios as nagios_map with context %}

nagios:
  pkg.installed:
    - pkgs: {{ nagios_map.packages }}

  service.running:
    - name: {{ nagios_map.service }}
    - enable: true
    - require:
      - pkg: nagios
