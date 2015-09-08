#!stateconf
{% from 'states/bind/map.jinja' import bind as bind_map with context %}

.params:
    stateconf.set: []
# --- end of state config ---

{% for family in ['ipv4', 'ipv6'] %}
{% for proto in ['tcp', 'udp'] %}
bind-iptables-{{ family }}-{{ proto }}:
  iptables.append:
    - table: filter
    - chain: TCPUDPLOCAL
    - proto: {{ proto }}
    - jump: ACCEPT
    - dport: {{ bind_map.port }}
    - family: {{ family }}
    - save: true
    - match: comment
    - comment: BIND DNS server
{% endfor %}
{% endfor %}
