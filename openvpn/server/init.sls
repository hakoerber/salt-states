#!stateconf
{% from 'states/openvpn/map.jinja' import openvpn as openvpn_map with context %}
{% from 'states/defaults.map.jinja' import defaults with context %}

.params:
    stateconf.set: []
# --- end of state config ---

{% for vpn in params.vpns %}
openvpn-server-{{ vpn.name }}-service:
  service.running:
{% if '%s' in openvpn_map.server.service %}
    - name: {{ openvpn_map.server.service|format('server-' + vpn.name) }}
{% else %}
    - name: {{ openvpn_map.server.service }}
{% endif %}

    - enable: True
    - require:
      - pkg: openvpn
{% endfor %}
