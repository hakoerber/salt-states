#!stateconf
{% from 'ntp/map.jinja' import ntp as ntp_map with context %}

.params:
    stateconf.set: []
# --- end of state config ---

{% if params.is_server %}
ntp-iptables-ipv4-udp:
  iptables.append:
    - table: filter
    - chain: TCPUDPLOCAL
    - proto: udp
    - jump: ACCEPT
    - dport: 123
    - family: ipv4
    - save: true
    - match: comment
    - comment: NTP Server
{% endif %}

