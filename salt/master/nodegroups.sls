#!stateconf
{% from 'states/salt/map.jinja' import salt as salt_map with context %}
{% from 'states/defaults.map.jinja' import defaults with context %}

.params:
    stateconf.set: []
# --- end of state config ---

salt-nodegroups-conf:
  file.managed:
    - name: {{ salt_map.master.conf_dir }}/nodegroups.conf
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 640
    - source: salt://states/salt/files/nodegroups.conf.jinja
    - defaults:
        nodegroups: {{ params.nodegroups }}
    - template: jinja
    - watch_in:
      - service: salt-master
