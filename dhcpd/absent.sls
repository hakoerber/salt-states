{% from 'states/dhcpd/map.jinja' import dhcpd as dhcpd_map with context %}

dhcpd:
  pkg.removed:
    - name: {{ dhcpd_map.package }}

  service.dead:
    - name: {{ dhcpd_map.service }}
    - enable: false
