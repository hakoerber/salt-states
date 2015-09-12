#!stateconf
{% from 'states/ssh/map.jinja' import ssh as ssh_map with context %}

.params:
    stateconf.set: []
# --- end of state config ---

{% for family in ['ipv4'] %}
ssh-server-iptables-{{ family }}:
  iptables.append:
    - table: filter
    - chain: ZONE_PUBLIC
    - proto: tcp
    - jump: ACCEPT
    - dports: {{ ssh_map.server.ports }}
    - family: {{ family }}
    - save: true
    - match: comment
    - comment: ssh-server
    - require:
      - iptables: chain_zone_public_ipv4
{% endfor %}
