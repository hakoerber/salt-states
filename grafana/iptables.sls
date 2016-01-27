{% from 'states/grafana/map.jinja' import grafana as grafana_map with context %}

{% for proto, ports in grafana_map.ports.items() %}
grafana-iptables-{{ proto }}:
  iptables.append:
    - table: filter
    - chain: ZONE_LOCAL
    - proto: {{ proto }}
    - jump: ACCEPT
    - dports: {{ ports }}
    - family: ipv4
    - save: true
    - match: comment
    - comment: grafana
{% endfor %}

