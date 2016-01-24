#!stateconf
{% from 'states/nagios/map.jinja' import nagios as nagios_map with context %}

.params:
    stateconf.set: []
# --- end of state config ---

{% set server_ips = [] %}
{% for server in params.servers %}
{% do server_ips.append(server.ip) %}
{% endfor %}

{% set port = params.get('port', nagios_map.check_mk.agent.port) %}
check_mk-agent-iptables:
  iptables.append:
    - table: filter
    - chain: ZONE_LOCAL
    - proto: tcp
    - jump: ACCEPT
    - source: {{ server_ips|join(',') }}
    - dports: {{ port }}
    - family: ipv4
    - save: true
    - match: comment
    - comment: check_mk agent
    - require:
      - iptables: chain_zone_local_ipv4
