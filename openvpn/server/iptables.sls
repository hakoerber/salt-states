#!stateconf
{% from 'states/openvpn/map.jinja' import openvpn as openvpn_map with context %}

.params:
    stateconf.set: []
# --- end of state config ---

{% for vpn in params.vpns %}
{% for family in ['ipv4', 'ipv6'] %}
{% set chain = 'VPN_' + vpn.name|upper %}

openvpn-iptables-{{ family }}-access-vpn-{{ vpn.name }}:
  iptables.append:
    - table: filter
    - chain: ZONE_PUBLIC
    - proto: udp
    - jump: ACCEPT
    - dport: {{ vpn.port|default(openvpn_map.default_port) }}
    - family: {{ family }}
    - save: True
    - match: comment
    - comment: OpenVPN {{ vpn.name }}
    - require:
      - iptables: chain_zone_public_{{ family }}

openvpn-iptables-{{ family }}-chain-vpn-{{ vpn.name }}:
  iptables.chain_present:
    - name: {{ chain }}
    - family: {{ family }}

openvpn-iptables-{{ family }}-jump_forward_inbound_vpn_{{ vpn.name }}:
  iptables.append:
    - table: filter
    - chain: FORWARD
    - in-interface: {{ vpn.devname }}
    - jump: {{ chain }}
    - family: {{ family }}
    - save: true
    - require:
      - iptables: openvpn-iptables-{{ family }}-chain-vpn-{{ vpn.name }}

openvpn-iptables-{{ family }}-jump_forward_outbound_vpn_{{ vpn.name }}:
  iptables.append:
    - table: filter
    - chain: FORWARD
    - out-interface: {{ vpn.devname }}
    - jump: {{ chain }}
    - family: {{ family }}
    - save: true
    - require:
      - iptables: openvpn-iptables-{{ family }}-chain-vpn-{{ vpn.name }}

openvpn-iptables-{{ family }}-allow_forward_all_vpn_{{ vpn.name }}:
  iptables.append:
    - table: filter
    - chain: {{ chain }}
    - jump: ACCEPT
    - family: {{ family }}
    - save: true
    - require:
      - iptables: openvpn-iptables-{{ family }}-chain-vpn-{{ vpn.name }}
{% endfor %}
{% endfor %}
