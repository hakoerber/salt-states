#!stateconf
{% from 'states/syncrepo/map.jinja' import syncrepo as syncrepo_map with context %}
{% from 'states/defaults.map.jinja' import defaults with context %}

.params:
    stateconf.set: []
# --- end of state config ---

syncrepo.conf:
  file.managed:
    - name: {{ syncrepo_map.conf_file }}
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 644
    - source: salt://states/syncrepo/files/syncrepo.conf.jinja
    - template: jinja
    - defaults:
        params: {{ params }}
