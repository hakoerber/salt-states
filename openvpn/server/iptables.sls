#!stateconf
{% from 'states/openvpn/map.jinja' import openvpn as openvpn_map with context %}

.params:
    stateconf.set: []
# --- end of state config ---

{% for vpnname, vpn in params.vpns.items() %}
{% set chain = 'VPN_' + vpnname|upper %}

openvpn-access-vpn-{{ vpnname }}:
  iptables.append:
    - table: filter
    - chain: ZONE_PUBLIC
    - proto: udp
    - jump: ACCEPT
    - dport: {{ vpn.port|default(openvpn_map.default_port) }}
    - family: ipv4
    - save: True
    - match: comment
    - comment: OpenVPN {{ vpnname }}
    - require:
      - iptables: chain_zone_public_ipv4

openvpn-chain-vpn-{{ vpnname }}:
  iptables.chain_present:
    - name: {{ chain }}

openvpn-jump_forward_inbound_vpn_{{ vpnname }}:
  iptables.append:
    - table: filter
    - chain: FORWARD
    - in-interface: {{ vpn.devname }}
    - jump: {{ chain }}
    - save: true
    - require:
      - iptables: openvpn-chain-vpn-{{ vpnname }}

openvpn-jump_forward_outbound_vpn_{{ vpnname }}:
  iptables.append:
    - table: filter
    - chain: FORWARD
    - out-interface: {{ vpn.devname }}
    - jump: {{ chain }}
    - save: true
    - require:
      - iptables: openvpn-chain-vpn-{{ vpnname }}

openvpn-allow_forward_all_vpn_{{ vpnname }}:
  iptables.append:
    - table: filter
    - chain: {{ chain }}
    - jump: ACCEPT
    - save: true
    - require:
      - iptables: openvpn-chain-vpn-{{ vpnname }}
{% endfor %}
