#!stateconf
{% from 'states/nagios/map.jinja' import nagios as nagios_map with context %}
{% from 'states/defaults.map.jinja' import defaults with context %}

.params:
    stateconf.set: []
# --- end of state config ---

notifications.mk:
  file.managed:
    - name: {{ nagios_map.check_mk.server.confdir }}/notifications.mk
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 644
    - source: salt://states/nagios/files/notifications.mk.jinja
    - template: jinja
    - defaults:
        params: {{ params }}
    - require:
      - pkg: check_mk-server
    - onchanges_in:
      - cmd: check_mk-update
