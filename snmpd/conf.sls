#!stateconf
{% from 'states/snmpd/map.jinja' import snmpd as snmpd_map with context %}
{% from 'states/defaults.map.jinja' import defaults with context %}

.params:
    stateconf.set: []
# --- end of state config ---

snmpd_config:
  file.managed:
    - name: {{ snmpd_map.conf_file }}
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 600
    - source: salt://states/snmpd/files/snmpd.conf.jinja
    - template: jinja
    - context:
      sysinfo: {{ params.sysinfo }}
    - require:
      - pkg: snmpd
    - watch_in:
      - service: snmpd
