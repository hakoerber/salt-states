#!stateconf
{% from 'states/cobbler/map.jinja' import cobbler as cobbler_map with context %}

.params:
    stateconf.set: []
# --- end of state config ---

{% for bool, value in cobbler_map.selinux.items() %}
cobbler-selinux-{{ bool }}:
  selinux.boolean:
    - name: {{ bool }}
    - value: {{ value }}
    - persist: True
{% endfor %}
