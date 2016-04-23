#!stateconf
{% from 'states/motd/map.jinja' import motd as motd_map with context %}
{% from 'states/defaults.map.jinja' import defaults with context %}

.params:
    stateconf.set: []
# --- end of state config ---

motd:
  file.managed:
    - name: {{ motd_map.path }}
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 644
    - source: salt://states/motd/files/motd.jinja
    - template: jinja
    - defaults:
        domains: {{ params.get('domains', []) }}
        networks: {{ params.get('networks', []) }}
        roles: {{ params.get('roles', []) }}
