#!stateconf
{% from 'states/salt/map.jinja' import salt as salt_map with context %}
{% from 'states/defaults.map.jinja' import defaults with context %}

.params:
    stateconf.set: []
# --- end of state config ---

salt-inventory-conf:
  file.managed:
    - name: {{ salt_map.master.conf_dir }}/inventory.conf
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 640
    - source: salt://states/salt/files/inventory.conf.jinja
    - template: jinja
    - watch_in:
      - service: salt-master
    - require:
      - pkg: reclass

reclass:
  pkg.installed:
    - pkgs: {{ salt_map.master.inventory.reclass.packages }}
