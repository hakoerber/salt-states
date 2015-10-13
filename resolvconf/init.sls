#!stateconf
{% from 'states/resolvconf/map.jinja' import resolvconf as resolvconf_map with context %}
{% from 'states/defaults.map.jinja' import defaults with context %}

.params:
    stateconf.set: []
# --- end of state config ---

resolvconf:
  file.managed:
    - name: {{ resolvconf_map.resolv }}
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 644
    - source: salt://states/resolvconf/files/resolv.conf.jinja
    - template: jinja
    - defaults:
        search: {{ params.search }}
        nameservers: {{ params.nameservers }}
