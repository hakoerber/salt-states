{% from 'states/subsonic/map.jinja' import subsonic as subsonic_map with context %}

{% for proto in subsonic_map.ports.keys() %}
subsonic_iptables:
  iptables.append:
    - table: filter
    - chain: ZONE_LOCAL
    - proto: {{ proto }}
    - jump: ACCEPT
    - dports: {{ subsonic_map.ports.get(proto) }}
    - family: ipv4
    - save: true
    - match: comment
    - comment: subsonic-web
{% endfor %}
