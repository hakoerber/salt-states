#!stateconf
{% from 'states/bind/map.jinja' import bind as bind_map with context %}

.params:
    stateconf.set: []
# --- end of state config ---

{% for family in ['ipv4'] %}
{% for proto in ['tcp', 'udp'] %}
bind-iptables-{{ family }}-{{ proto }}:
  iptables.append:
    - table: filter
    - chain: ZONE_LOCAL
    - proto: {{ proto }}
    - jump: ACCEPT
    - dport: {{ bind_map.port }}
    - family: {{ family }}
    - save: true
    - match: comment
    - comment: BIND DNS server
    - require:
      - iptables: chain_zone_local_ipv4
{% endfor %}
{% endfor %}
