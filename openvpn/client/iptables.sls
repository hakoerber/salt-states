#!stateconf
.params:
    stateconf.set: []
# --- end of state config ---

{% for vpn in params.vpns %}
{% set chain = 'VPN_' + vpn.name|upper %}

openvpn-chain-vpn-{{ vpn.name }}:
  iptables.chain_present:
    - name: {{ chain }}

openvpn-jump_forward_inbound_vpn_{{ vpn.name }}:
  iptables.append:
    - table: filter
    - chain: FORWARD
    - in-interface: {{ vpn.devname }}
    - jump: {{ chain }}
    - save: true
    - require:
      - iptables: openvpn-chain-vpn-{{ vpn.name }}

openvpn-jump_forward_outbound_vpn_{{ vpn.name }}:
  iptables.append:
    - table: filter
    - chain: FORWARD
    - out-interface: {{ vpn.devname }}
    - jump: {{ chain }}
    - save: true
    - require:
      - iptables: openvpn-chain-vpn-{{ vpn.name }}

{% set client_options = vpn.client.options %}

{% if client_options.get('allow_forward') == 'all' %}
openvpn-allow_forward_all_vpn_{{ vpn.name }}:
  iptables.append:
    - table: filter
    - chain: {{ chain }}
    - jump: ACCEPT
    - save: true
    - require:
      - iptables: openvpn-chain-vpn-{{ vpn.name }}

{% else %}
{% if client_options.allow_forward is defined %}
openvpn-allow_selective_forward_inbound_vpn_{{ vpn.name }}:
  iptables.append:
    - table: filter
    - chain: {{ chain }}
    - jump: ACCEPT
    - destination: {{ client_options.allow_forward|join(',') }}
    - save: true
    - require:
      - iptables: openvpn-chain-vpn-{{ vpn.name }}
    - require_in:
      - iptables: openvpn-deny_forward_vpn_{{ vpn.name }}

openvpn-allow_selective_forward_outbound_vpn_{{ vpn.name }}:
  iptables.append:
    - table: filter
    - chain: {{ chain }}
    - jump: ACCEPT
    - source: {{ client_options.allow_forward|join(',') }}
    - save: true
    - require:
      - iptables: openvpn-chain-vpn-{{ vpn.name }}
    - require_in:
      - iptables: openvpn-deny_forward_vpn_{{ vpn.name }}
{% endif %}

openvpn-deny_forward_vpn_{{ vpn.name }}:
  iptables.append:
    - table: filter
    - chain: {{ chain }}
    - jump: REJECT
    - save: true
    - require:
      - iptables: openvpn-chain-vpn-{{ vpn.name }}
{% endif %}

{% endfor %}
