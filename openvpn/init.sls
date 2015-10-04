{% from 'states/openvpn/map.jinja' import openvpn as openvpn_map with context %}

openvpn:
  pkg.installed:
    - name: {{ openvpn_map.package }}
