{% from 'states/nagios/map.jinja' import nagios as nagios_map with context %}

{% for proto, ports in nagios_map.check_mk.server.ports.items() %}
nagios_iptables-{{ proto }}:
  iptables.append:
    - table: filter
    - chain: ZONE_LOCAL
    - proto: {{ proto }}
    - jump: ACCEPT
    - dports: {{ ports }}
    - family: ipv4
    - save: true
    - match: comment
    - comment: check_mk server
{% endfor %}
