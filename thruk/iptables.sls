{% from 'states/thruk/map.jinja' import thruk as thruk_map with context %}

{% for proto, ports in thruk_map.ports.items() %}
thruk-iptables-{{ proto }}:
  iptables.append:
    - table: filter
    - chain: ZONE_LOCAL
    - proto: {{ proto }}
    - jump: ACCEPT
    - dports: {{ ports }}
    - family: ipv4
    - save: true
    - match: comment
    - comment: thruk
{% endfor %}

