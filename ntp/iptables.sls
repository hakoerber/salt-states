#!stateconf

.params:
    stateconf.set: []
# --- end of state config ---

{% if params.is_server %}
ntp-iptables-ipv4-udp:
  iptables.append:
    - table: filter
    - chain: ZONE_LOCAL
    - proto: udp
    - jump: ACCEPT
    - dport: 123
    - family: ipv4
    - save: true
    - match: comment
    - comment: NTP Server
    - require:
      - iptables: chain_zone_local_ipv4
{% endif %}
