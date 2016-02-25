#!stateconf
{% from 'states/ssh/map.jinja' import ssh as ssh_map with context %}
{% from 'states/defaults.map.jinja' import defaults with context %}

.params:
    stateconf.set: []
# --- end of state config ---

{% for keytype in ssh_map.server.keytypes %}
hostkey-{{ keytype }}:
  file.managed:
    - name: /etc/ssh/ssh_host_{{ keytype }}_key
    - mode: 600
    - user: root
    - group: {{ defaults.rootgroup }}
    - contents_pillar: ssh:hostkeys:ssh_host_{{ keytype }}_key
    - show_diff: false
    - watch_in:
      - service: ssh-server

hostkey-{{ keytype }}-pub:
  file.managed:
    - name: /etc/ssh/ssh_host_{{ keytype }}_key.pub
    - mode: 644
    - user: root
    - group: {{ defaults.rootgroup }}
    - contents_pillar: ssh:hostkeys:ssh_host_{{ keytype }}_key.pub
    - show_diff: false
    - watch_in:
      - service: ssh-server
{% endfor %}
