#!stateconf
{% from 'states/salt/map.jinja' import salt as salt_map with context %}
{% from 'states/defaults.map.jinja' import defaults with context %}

.params:
    stateconf.set: []
# --- end of state config ---


salt-minion-conf:
  file.managed:
    - name: {{ salt_map.minion.conf_file }}
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 640
    - source: salt://states/salt/files/minion.jinja
    - template: jinja
    - defaults:
        master: {{ params.master }}
    - watch_in:
      - cmd: salt-restart-minion
