#!stateconf
{% from 'states/gogs/map.jinja' import gogs as gogs_map with context %}
{% from 'states/defaults.map.jinja' import defaults with context %}

.params:
    stateconf.set: []
# --- end of state config ---

gogs-settings:
  file.managed:
    - name: {{ gogs_map.conf_file }}
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 644
    - source: salt://states/gogs/files/app.ini.jinja2
    - defaults:
        params: {{ params.server }}
    - template: jinja
    - watch_in:
      - service: gogs
