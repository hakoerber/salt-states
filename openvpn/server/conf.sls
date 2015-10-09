#!stateconf
{% from 'states/openvpn/map.jinja' import openvpn as openvpn_map with context %}
{% from 'states/defaults.map.jinja' import defaults with context %}

.params:
    stateconf.set: []
# --- end of state config ---

{% for vpnname, vpn in params.vpns.items() %}
openvpn-server-{{ vpnname }}.conf:
  file.managed:
    - name: {{ openvpn_map.confdir }}/server-{{ vpnname }}.conf
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 644
    - source: salt://states/openvpn/files/server.conf.jinja
    - template: jinja
    - defaults:
        vpnname: {{ vpnname }}
        vpn: {{ vpn }}
    - watch_in:
      - service: openvpn-server-{{ vpnname }}-service
    - require:
      - pkg: openvpn
      - file: openvpn-server-{{ vpnname }}-ccd

openvpn-server-{{ vpnname }}-ccd:
  file.directory:
    - name: {{ openvpn_map.confdir }}/{{ vpnname }}.ccd
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 755

{% for clientname, clientinfo in vpn.get('clients', {}).items() %}
{% set conf = clientinfo.options %}
{% if conf.get('ip', 'dhcp') != 'dhcp' or conf.advertise_subnet is defined %}
openvpn-server-{{ vpnname }}-ccd-{{ clientname }}:
  file.managed:
    - name: {{ openvpn_map.confdir }}/{{ vpnname }}.ccd/{{ clientname }}
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 644
    - source: salt://states/openvpn/files/server.ccd.jinja
    - template: jinja
    - context:
        client_conf: {{ conf }}
        vpn: {{ vpn }}
    - require:
      - file: openvpn-server-{{ vpnname }}-ccd
{% endif %}
{% endfor %}

{% endfor %}
