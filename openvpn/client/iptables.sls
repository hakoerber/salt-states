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

{% set client_options = vpn.clients.get(grains['id'], {}).get('options', {}) %}

{% if client_options.get('allow_forward') == 'all' %}
openvpn-allow_forward_all_vpn_{{ vpnname }}:
  iptables.append:
    - table: filter
    - chain: {{ chain }}
    - jump: ACCEPT
    - save: true
    - require:
      - iptables: openvpn-chain-vpn-{{ vpnname }}

{% else %}
{% if client_options.allow_forward is defined %}
openvpn-allow_selective_forward_inbound_vpn_{{ vpnname }}:
  iptables.append:
    - table: filter
    - chain: {{ chain }}
    - jump: ACCEPT
    - destination: {{ client_options.allow_forward|join(',') }}
    - save: true
    - require:
      - iptables: openvpn-chain-vpn-{{ vpnname }}
    - require_in:
      - iptables: openvpn-deny_forward_vpn_{{ vpnname }}:

openvpn-allow_selective_forward_outbound_vpn_{{ vpnname }}:
  iptables.append:
    - table: filter
    - chain: {{ chain }}
    - jump: ACCEPT
    - source: {{ client_options.allow_forward|join(',') }}
    - save: true
    - require:
      - iptables: openvpn-chain-vpn-{{ vpnname }}
    - require_in:
      - iptables: openvpn-deny_forward_vpn_{{ vpnname }}:
{% endif %}

openvpn-deny_forward_vpn_{{ vpnname }}:
  iptables.append:
    - table: filter
    - chain: {{ chain }}
    - jump: REJECT
    - save: true
    - require:
      - iptables: openvpn-chain-vpn-{{ vpnname }}
{% endif %}

{% endfor %}
