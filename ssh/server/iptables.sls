#!stateconf
{% from 'states/ssh/map.jinja' import ssh as ssh_map with context %}

.params:
    stateconf.set: []
# --- end of state config ---

{% if grains['os_family'] != 'FreeBSD' %}
{% for family in ['ipv4', 'ipv6'] %}
ssh-server-iptables-{{ family }}:
  iptables.append:
    - table: filter
    - chain: TCPUDPPUBLIC
    - proto: tcp
    - jump: ACCEPT
    - dports: {{ ssh_map.server.ports }}
    - family: {{ family }}
    - save: true
    - match: comment
    - comment: ssh-server
{% endfor %}
{% endif %}
