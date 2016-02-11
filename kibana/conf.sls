#!stateconf
{% from 'states/kibana/map.jinja' import kibana as kibana_map with context %}
{% from 'states/defaults.map.jinja' import defaults with context %}

.params:
    stateconf.set: []
# --- end of state config ---

named.conf:
  file.managed:
    - name: {{ kibana_map.conf }}
    - user: root
    - group: named
    - mode: 640
    - source: 'salt://states/kibana/files/kibana.yml.jinja'
    - template: jinja
    - defaults:
        params: {{ params }}
    - require:
      - pkg: kibana
    - watch_in:
      - service: kibana
