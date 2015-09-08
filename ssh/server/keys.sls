#!stateconf
{% from 'states/ssh/map.jinja' import ssh as ssh_map with context %}

.params:
    stateconf.set: []
# --- end of state config ---

{% for keytype in ssh_map.server.keytypes %}
hostkey-{{ keytype }}:
  file.managed:
    - name: /etc/ssh/ssh_host_{{ keytype }}_key
    - mode: 600
    - user: root
    - group: {{ ssh_map.rootgroup }}
    - source: salt://files/ssh/hostkeys/{{ grains['id'] }}/ssh_host_{{ keytype }}_key
    - show_diff: false

hostkey-{{ keytype }}-pub:
  file.managed:
    - name: /etc/ssh/ssh_host_{{ keytype }}_key.pub
    - mode: 644
    - user: root
    - group: {{ ssh_map.rootgroup }}
    - source: salt://files/ssh/hostkeys/{{ grains['id'] }}//ssh_host_{{ keytype }}_key.pub
    - show_diff: false
{% endfor %}


