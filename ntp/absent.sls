{% from 'states/ntp/map.jinja' import ntp as ntp_map with context %}

ntp:
  pkg.removed:
    - name: {{ ntp_map.package }}

  service.dead:
    - name: {{ ntp_map.service }}
    - enable: false
