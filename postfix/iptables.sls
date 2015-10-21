{% from 'states/postfix/map.jinja' import postfix as postfix_map with context %}

{% for family in ['ipv4'] %}
postfix-iptables-{{ family }}:
  iptables.append:
    - table: filter
    - chain: ZONE_PUBLIC
    - proto: tcp
    - jump: ACCEPT
    - dport: {{ postfix_map.ports.receive }}
    - family: {{ family }}
    - save: true
    - match: comment
    - comment: postfix
    - require:
      - iptables: chain_zone_public_ipv4
{% endfor %}
