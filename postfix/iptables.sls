#!stateconf
{% from 'states/postfix/map.jinja' import postfix as postfix_map with context %}

.params:
    stateconf.set: []
# --- end of state config ---

{% for family in ['ipv4'] %}
postfix-iptables-{{ family }}-receive:
  iptables.append:
    - table: filter
    - chain: ZONE_PUBLIC
    - proto: tcp
    - jump: ACCEPT
    - dport: {{ postfix_map.ports.receive }}
    - family: {{ family }}
    - save: true
    - match: comment
    - comment: postfix-receive
    - require:
      - iptables: chain_zone_public_ipv4

{% if params.get('auth', none) is not none %}
postfix-iptables-{{ family }}-submit:
  iptables.append:
    - table: filter
    - chain: ZONE_PUBLIC
    - proto: tcp
    - jump: ACCEPT
    - dport: {{ postfix_map.ports.submit }}
    - family: {{ family }}
    - save: true
    - match: comment
    - comment: postfix-submit
    - require:
      - iptables: chain_zone_public_ipv4
{% endif %}
{% endfor %}
