#!stateconf
{% from 'states/ssh/map.jinja' import ssh as ssh_map with context %}

.params:
    stateconf.set: []
# --- end of state config ---

ssh-server:
  {% if ssh_map.server.package != None %}
  pkg.installed:
    - name: {{ ssh_map.server.package }}
    - require_in:
      - service: ssh-server
  {% endif %}

  service.running:
    - name: {{ ssh_map.server.service }}
    - enable: true
