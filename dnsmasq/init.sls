{% from 'states/dnsmasq/map.jinja' import dnsmasq as dnsmasq_map with context %}

dnsmasq:
  pkg.installed:
    - name: {{ dnsmasq_map.package }}

  service.running:
    - name: {{ dnsmasq_map.service }}
    - enable: true
    - require:
      - pkg: dnsmasq
