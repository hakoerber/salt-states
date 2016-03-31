#!stateconf
{% from 'states/cobbler/map.jinja' import cobbler as cobbler_map with context %}
{% from 'states/defaults.map.jinja' import defaults with context %}

.params:
    stateconf.set: []
# --- end of state config ---

cobbler-settings:
  file.managed:
    - name: {{ cobbler_map.conf_file }}
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 644
    - source: salt://states/cobbler/files/settings.jinja
    - defaults:
        default_password: {{ params.default_password }}
    - template: jinja
    - watch_in:
      - service: cobbler

cobbler-sync:
  cmd.run:
    - name: cobbler sync
    - user: root
    - group: {{ defaults.rootgroup }}
    - onchanges:
      - file: cobbler-settings
