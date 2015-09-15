#!stateconf
{% from 'states/nagios/map.jinja' import nagios as nagios_map with context %}

.params:
    stateconf.set: []
# --- end of state config ---

{% set port = params.get('port', nagios_map.check_mk.agent.port) %}
check_mk-agent-iptables:
  iptables.append:
    - table: filter
    - chain: ZONE_LOCAL
    - proto: tcp
    - jump: ACCEPT
    - source: {{ params.servers|map(attribute='ip')|join(',') }}
    - dports: {{ port }}
    - family: ipv4
    - save: true
    - match: comment
    - comment: check_mk agent
    - require:
      - iptables: chain_zone_local_ipv4
