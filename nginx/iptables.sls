#!stateconf
{% from 'states/nginx/map.jinja' import nginx as nginx_map with context %}

.params:
    stateconf.set: []
# --- end of state config ---

{% for family in (['ipv4', 'ipv6'] if params.get('ipv6', False) else ['ipv4']) %}
{% for protocol in ['http', 'https'] %}
{% if params[protocol] %}
nginx-iptables-{{ protocol }}-{{ family }}:
  iptables.append:
    - table: filter
    - chain: {{ 'ZONE_PUBLIC' if params.get('public', False) else 'ZONE_LOCAL' }}
    - proto: tcp
    - jump: ACCEPT
    - dport: {{ nginx_map.ports[protocol] }}
    - family: {{ family }}
    - save: true
    - match: comment
    - comment: nginx {{ protocol|upper }}
    - require:
{% if params.get('public', False) %}
      - iptables: chain_zone_public_{{ family }}
{% else %}
      - iptables: chain_zone_local_{{ family }}
{% endif %}
{% endif %}
{% endfor %}
{% endfor %}
