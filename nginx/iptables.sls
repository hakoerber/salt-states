#!stateconf
{% from 'states/nginx/map.jinja' import nginx as nginx_map with context %}

.params:
    stateconf.set: []
# --- end of state config ---

{% for protocol in ['http', 'https'] %}
{% if params[protocol] %}
nginx-iptables-{{ protocol }}:
  iptables.append:
    - table: filter
    - chain: {{ 'ZONE_PUBLIC' if params.get('public', False) else 'ZONE_LOCAL' }}
    - proto: tcp
    - jump: ACCEPT
    - dport: {{ nginx_map.ports[protocol] }}
    - family: ipv4
    - save: true
    - match: comment
    - comment: nginx {{ protocol|upper }}
    - require:
      - iptables: chain_zone_local_ipv4
{% endif %}
{% endfor %}
