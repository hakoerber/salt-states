#!stateconf
{% from 'states/openvpn/map.jinja' import openvpn as openvpn_map with context %}
{% from 'states/defaults.map.jinja' import defaults with context %}

.params:
    stateconf.set: []
# --- end of state config ---

openvpn-keydir:
  file.directory:
    - name: {{ openvpn_map.confdir }}/{{ openvpn_map.pkidir }}
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 700

{% for vpnname, vpn in params.vpns.items() %}

openvpn-keydir-{{ vpnname }}:
  file.directory:
    - name: {{ openvpn_map.confdir }}/{{ openvpn_map.pkidir }}/{{ vpnname }}
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 700
    - require:
      - file: openvpn-keydir
    - watch_in:
      - service: openvpn-server-{{ vpnname }}-service
    - require_in:
      - file: openvpn-server-{{ vpnname }}.conf

openvpn-ca-cert-{{ vpnname }}:
  file.managed:
    - name: {{ openvpn_map.confdir }}/{{ openvpn_map.pkidir }}/{{ vpnname }}/ca.crt
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 600
    - source: salt://files/openvpn/{{ vpnname }}/shared/ca.crt
    - show_diff: false
    - require:
      - file: openvpn-keydir-{{ vpnname }}
    - watch_in:
      - service: openvpn-server-{{ vpnname }}-service

openvpn-tls-auth-key-{{ vpnname }}:
  file.managed:
    - name: {{ openvpn_map.confdir }}/{{ openvpn_map.pkidir }}/{{ vpnname }}/ta.key
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 600
    - source: salt://files/openvpn/{{ vpnname }}/shared/ta.key
    - show_diff: false
    - require:
      - file: openvpn-keydir-{{ vpnname }}
    - watch_in:
      - service: openvpn-server-{{ vpnname }}-service

{% set common_name = grains['id'] %}

openvpn-server-cert-{{ vpnname }}:
  file.managed:
    - name: {{ openvpn_map.confdir }}/{{ openvpn_map.pkidir }}/{{ vpnname }}/server.crt
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 600
    - source: salt://files/openvpn/{{ vpnname }}/servers/{{ common_name }}/server.crt
    - show_diff: false
    - require:
      - file: openvpn-keydir-{{ vpnname }}
    - watch_in:
      - service: openvpn-server-{{ vpnname }}-service

openvpn-server-key-{{ vpnname }}:
  file.managed:
    - name: {{ openvpn_map.confdir }}/{{ openvpn_map.pkidir }}/{{ vpnname }}/server.key
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 600
    - source: salt://files/openvpn/{{ vpnname }}/servers/{{ common_name }}/server.key
    - show_diff: false
    - require:
      - file: openvpn-keydir-{{ vpnname }}
    - watch_in:
      - service: openvpn-server-{{ vpnname }}-service

openvpn-server-dh-{{ vpnname }}:
  file.managed:
    - name: {{ openvpn_map.confdir }}/{{ openvpn_map.pkidir }}/{{ vpnname }}/dh2048.pem
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 600
    - source: salt://files/openvpn/{{ vpnname }}/servers/common/dh2048.pem
    - show_diff: false
    - require:
      - file: openvpn-keydir-{{ vpnname }}
    - watch_in:
      - service: openvpn-server-{{ vpnname }}-service
{% endfor %}
