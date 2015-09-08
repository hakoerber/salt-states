#!stateconf
{% from 'states/bind/map.jinja' import bind as bind_map with context %}

.params:
    stateconf.set: []
# --- end of state config ---

bind:
  pkg.installed:
    - name: {{ bind_map.package }}

  service.running:
    - name: {{ bind_map.service }}
    - enable: true
    - require:
      - pkg: bind
