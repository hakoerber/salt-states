#!stateconf
{% from 'states/openvpn/map.jinja' import openvpn as openvpn_map with context %}
{% from 'states/defaults.map.jinja' import defaults with context %}

.params:
    stateconf.set: []
# --- end of state config ---

{% set forward = [] %}
{% for vpn in params.vpns %}
{% set client_options = vpn.client.get('options', {}) %}
{% if client_options.get('allow_forward') is not none %}
{% do forward.append(1)%}
{% endif %}
{% endfor %}

{% if forward %}
ip_forward:
  sysctl.present:
    - name: net.ipv4.ip_forward
    - value: 1
{% endif %}
