#!stateconf
{% from 'states/openvpn/map.jinja' import openvpn as openvpn_map with context %}
{% from 'states/defaults.map.jinja' import defaults with context %}

.params:
    stateconf.set: []
# --- end of state config ---

{% for vpnname, vpn in params.vpns.items() %}
openvpn-server-{{ vpnname }}-service:
  service.running:
    {% if '%s' in openvpn_map.server.service %}
    - name: {{ openvpn_map.server.service|format('server-' + vpnname) }}
    {% else %}
    - name: {{ openvpn_map.server.service }}
    {% endif %}

    - enable: True
    - require:
      - pkg: openvpn
{% endfor %}
