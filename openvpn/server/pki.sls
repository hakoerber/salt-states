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

{% for vpn in params.vpns %}

openvpn-keydir-{{ vpn.name }}:
  file.directory:
    - name: {{ openvpn_map.confdir }}/{{ openvpn_map.pkidir }}/{{ vpn.name }}
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 700
    - require:
      - file: openvpn-keydir
    - watch_in:
      - service: openvpn-server-{{ vpn.name }}-service
    - require_in:
      - file: openvpn-server-{{ vpn.name }}.conf

openvpn-ca-cert-{{ vpn.name }}:
  file.managed:
    - name: {{ openvpn_map.confdir }}/{{ openvpn_map.pkidir }}/{{ vpn.name }}/ca.crt
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 600
    - source: salt://files/openvpn/{{ vpn.name }}/shared/ca.crt
    - show_diff: false
    - require:
      - file: openvpn-keydir-{{ vpn.name }}
    - watch_in:
      - service: openvpn-server-{{ vpn.name }}-service

openvpn-tls-auth-key-{{ vpn.name }}:
  file.managed:
    - name: {{ openvpn_map.confdir }}/{{ openvpn_map.pkidir }}/{{ vpn.name }}/ta.key
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 600
    - source: salt://files/openvpn/{{ vpn.name }}/shared/ta.key
    - show_diff: false
    - require:
      - file: openvpn-keydir-{{ vpn.name }}
    - watch_in:
      - service: openvpn-server-{{ vpn.name }}-service

{% set common_name = grains['id'] %}

openvpn-server-cert-{{ vpn.name }}:
  file.managed:
    - name: {{ openvpn_map.confdir }}/{{ openvpn_map.pkidir }}/{{ vpn.name }}/server.crt
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 600
    - source: salt://files/openvpn/{{ vpn.name }}/server/server.crt
    - show_diff: false
    - require:
      - file: openvpn-keydir-{{ vpn.name }}
    - watch_in:
      - service: openvpn-server-{{ vpn.name }}-service

openvpn-server-key-{{ vpn.name }}:
  file.managed:
    - name: {{ openvpn_map.confdir }}/{{ openvpn_map.pkidir }}/{{ vpn.name }}/server.key
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 600
    - source: salt://files/openvpn/{{ vpn.name }}/server/server.key
    - show_diff: false
    - require:
      - file: openvpn-keydir-{{ vpn.name }}
    - watch_in:
      - service: openvpn-server-{{ vpn.name }}-service

openvpn-server-dh-{{ vpn.name }}:
  file.managed:
    - name: {{ openvpn_map.confdir }}/{{ openvpn_map.pkidir }}/{{ vpn.name }}/dh2048.pem
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 600
    - source: salt://files/openvpn/{{ vpn.name }}/server/dh2048.pem
    - show_diff: false
    - require:
      - file: openvpn-keydir-{{ vpn.name }}
    - watch_in:
      - service: openvpn-server-{{ vpn.name }}-service
{% endfor %}
