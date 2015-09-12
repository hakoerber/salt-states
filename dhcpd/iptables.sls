#!stateconf
{% from 'states/dhcpd/map.jinja' import dhcpd as dhcpd_map with context %}

.params:
    stateconf.set: []
# --- end of state config ---

dhcpd-iptables-ipv4:
  iptables.append:
    - table: filter
    - chain: ZONE_LOCAL
    - proto: udp
    - jump: ACCEPT
    - dports: {{ dhcpd_map.ports }}
    - family: ipv4
    - save: true
    - match: comment
    - comment: DHCP server
    - require:
      - iptables: chain_zone_local_ipv4

{% if params.role == 'primary' %}
{% set peer_ip = params.secondary.ip %}
{% else %}
{% set peer_ip = params.primary.ip %}
{% endif %}

dhcpd-iptables-ipv4-failover:
  iptables.append:
    - table: filter
    - chain: ZONE_LOCAL
    - proto: tcp
    - jump: ACCEPT
    - source: {{ peer_ip }}
    - dport: 647
    - family: ipv4 
    - save: true
    - match: comment
    - comment: DHCP server failover
