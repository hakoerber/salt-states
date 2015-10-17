#!stateconf
.params:
    stateconf.set: []
# --- end of state config ---

{% for vpnname, vpn in params.vpns.items() %}
{% set chain = 'VPN_' + vpnname|upper %}

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
