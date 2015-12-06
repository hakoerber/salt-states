{% from 'states/unifi/map.jinja' import unifi as unifi_map with context %}

{% for component, protos in unifi_map.controller.ports.items() %}
{% for proto, ports in protos.items() %}
unifi-iptables-{{ component }}-{{ proto }}:
  iptables.append:
    - table: filter
    - chain: ZONE_LOCAL
    - proto: {{ proto }}
    - jump: ACCEPT
    - dports: {{ ports }}
    - family: ipv4
    - save: true
    - match: comment
    - comment: unifi {{ component }}
{% endfor %}
{% endfor %}
