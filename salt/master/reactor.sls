#!stateconf
{% from 'states/salt/map.jinja' import salt as salt_map with context %}
{% from 'states/defaults.map.jinja' import defaults with context %}

.params:
    stateconf.set: []
# --- end of state config ---

salt-reactor-conf:
  file.managed:
    - name: {{ salt_map.master.conf_dir }}/reactor.conf
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 640
    - source: salt://states/salt/files/reactor.conf.jinja
    - defaults:
        events: {{ params.events }}
    - template: jinja
    - watch_in:
      - service: salt-master
