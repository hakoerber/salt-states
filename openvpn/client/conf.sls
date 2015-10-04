#!stateconf
{% from 'states/openvpn/map.jinja' import openvpn as openvpn_map with context %}
{% from 'states/defaults.map.jinja' import defaults with context %}

.params:
    stateconf.set: []
# --- end of state config ---

{% for vpnname, vpn in params.vpns.items() %}
openvpn-client-{{ vpnname }}.conf:
  file.managed:
    - name: {{ openvpn_map.confdir }}/client-{{ vpnname }}.conf
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 644
    - source: salt://states/openvpn/files/client.conf.jinja
    - template: jinja
    - require:
      - pkg: openvpn-client
    - defaults:
        vpnname: {{ vpnname }}
        vpn: {{ vpn }}
    - watch_in:
      - service: openvpn-client-{{ vpnname }}-service
    - require:
      - pkg: openvpn
{% endfor %}
