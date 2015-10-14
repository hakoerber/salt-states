{% from 'states/emby/map.jinja' import emby as emby_map with context %}

{% for proto in emby_map.ports.keys() %}
emby_iptables:
  iptables.append:
    - table: filter
    - chain: ZONE_LOCAL
    - proto: {{ proto }}
    - jump: ACCEPT
    - dports: {{ emby_map.ports.get(proto) }}
    - family: ipv4
    - save: true
    - match: comment
    - comment: emby-web
{% endfor %}
