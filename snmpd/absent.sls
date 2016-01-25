{% from 'states/snmpd/map.jinja' import snmpd as snmpd_map with context %}

snmpd:
  pkg.removed:
    - name: {{ snmpd_map.package }}
    - require:
      - service: snmpd

  service.dead:
    - name: {{ snmpd_map.service }}
    - enable: false
