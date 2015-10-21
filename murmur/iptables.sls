#!stateconf
{% from 'states/murmur/map.jinja' import murmur as murmur_map with context %}

{% for family in ['ipv4'] %}
murmur-iptables-tcp-{{ family }}:
  iptables.append:
    - table: filter
    - chain: ZONE_PUBLIC
    - proto: tcp
    - jump: ACCEPT
    - dport: {{ murmur_map.port }}
    - family: {{ family }}
    - save: true
    - match: comment
    - comment: murmur
    - require:
      - iptables: chain_zone_public_ipv4

murmur-iptables-udp-{{ family }}:
  iptables.append:
    - table: filter
    - chain: ZONE_PUBLIC
    - proto: udp
    - jump: ACCEPT
    - dport: {{ murmur_map.port }}
    - family: {{ family }}
    - save: true
    - match: comment
    - comment: murmur
    - require:
      - iptables: chain_zone_public_ipv4
{% endfor %}


