#!stateconf
{% from 'states/nagios/map.jinja' import nagios as nagios_map with context %}
{% from 'states/defaults.map.jinja' import defaults with context %}

.params:
    stateconf.set: []
# --- end of state config ---

main.mk:
  file.managed:
    - name: {{ nagios_map.check_mk.server.main_conf }}
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 644
    - source: salt://states/nagios/files/main.mk.jinja
    - template: jinja
    - defaults:
      params: {{ params }}
    - require:
      - pkg: check_mk-server
      
check_mk-update:
  cmd.run:
    - name: cmk --update
    - user: root
    - group: {{ defaults.rootgroup }}
    - onchanges:
      - file: main.mk
    - watch_in:
      - service: nagios
    - require:
      - cmd: check_mk-inventory

check_mk-inventory:
  cmd.run:
    - name: cmk -I
    - user: root
    - group: {{ defaults.rootgroup }}
    - onchanges:
      - file: main.mk
    - watch_in:
      - service: nagios
