#!stateconf
{% from 'states/snmpd/map.jinja' import snmpd as snmpd_map with context %}

.params:
    stateconf.set: []
# --- end of state config ---

snmpd:
  pkg.installed:
    - name: {{ snmpd_map.package }}

  service.running:
    - name: {{ snmpd_map.service }}
    - enable: true
    - require:
      - pkg: snmpd
