{% from 'states/dhcpd/map.jinja' import dhcpd as dhcpd_map with context %}

dhcpd:
  pkg.installed:
    - name: {{ dhcpd_map.package }}

  service.running:
    - name: {{ dhcpd_map.service }}
    - enable: true
    - require:
      - pkg: dhcpd
