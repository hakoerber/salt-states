{% from 'states/seafile/map.jinja' import seafile as seafile_map with context %}

{% for proto in seafile_map.ports.keys() %}
seafile_iptables-{{ proto }}:
  iptables.append:
    - table: filter
    - chain: ZONE_LOCAL
    - proto: {{ proto }}
    - jump: ACCEPT
    - dports: {{ seafile_map.ports.get(proto) }}
    - family: ipv4
    - save: true
    - match: comment
    - comment: seafile-web
{% endfor %}
