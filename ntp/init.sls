{% from 'states/ntp/map.jinja' import ntp as ntp_map with context %}

ntp:
  pkg.installed:
    - name: {{ ntp_map.package }}

  service.running:
    - name: {{ ntp_map.service }}
    - enable: true
    - require:
      - pkg: ntp
