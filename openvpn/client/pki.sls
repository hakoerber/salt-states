#!stateconf
{% from 'states/openvpn/map.jinja' import openvpn as openvpn_map with context %}
{% from 'states/defaults.map.jinja' import defaults with context %}

.params:
    stateconf.set: []
# --- end of state config ---

{% for vpnname, vpn in params.vpns.items() %}

openvpn-keydir-{{ vpnname }}:
  file.directory:
    - name: {{ openvpn_map.confdir }}/{{ openvpn_map.pkidir }}/{{ vpnname }}
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 700
    - makedirs: True
    - watch_in:
      - service: openvpn-client-{{ vpnname }}-service
    - require_in:
      - file: openvpn-client-{{ vpnname }}.conf
    - require:
      - pkg: openvpn

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
      - service: openvpn-client-{{ vpnname }}-service

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
      - service: openvpn-client-{{ vpnname }}-service

{% set common_name = grains['id'] %}

openvpn-client-cert-{{ vpnname }}:
  file.managed:
    - name: {{ openvpn_map.confdir }}/{{ openvpn_map.pkidir }}/{{ vpnname }}/client.crt
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 600
    - source: salt://files/openvpn/{{ vpnname }}/clients/{{ common_name }}/client.crt
    - show_diff: false
    - require:
      - file: openvpn-keydir-{{ vpnname }}
    - watch_in:
      - service: openvpn-client-{{ vpnname }}-service

openvpn-client-key-{{ vpnname }}:
  file.managed:
    - name: {{ openvpn_map.confdir }}/{{ openvpn_map.pkidir }}/{{ vpnname }}/client.key
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 600
    - source: salt://files/openvpn/{{ vpnname }}/clients/{{ common_name }}/client.key
    - show_diff: false
    - require:
      - file: openvpn-keydir-{{ vpnname }}
    - watch_in:
      - service: openvpn-client-{{ vpnname }}-service
{% endfor %}
