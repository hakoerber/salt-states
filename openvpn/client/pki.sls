#!stateconf
{% from 'states/openvpn/map.jinja' import openvpn as openvpn_map with context %}
{% from 'states/defaults.map.jinja' import defaults with context %}

.params:
    stateconf.set: []
# --- end of state config ---

openvpn-pkidir:
  file.directory:
    - name: {{ openvpn_map.confdir }}/{{ openvpn_map.pkidir }}
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 700
    - require:
      - pkg: openvpn

{% for vpn in params.vpns %}

openvpn-keydir-{{ vpn.name }}:
  file.directory:
    - name: {{ openvpn_map.confdir }}/{{ openvpn_map.pkidir }}/{{ vpn.name }}
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 700
    - watch_in:
      - service: openvpn-client-{{ vpn.name }}-service
    - require_in:
      - file: openvpn-client-{{ vpn.name }}.conf
    - require:
      - pkg: openvpn
      - file: openvpn-pkidir

openvpn-ca-cert-{{ vpn.name }}:
  file.managed:
    - name: {{ openvpn_map.confdir }}/{{ openvpn_map.pkidir }}/{{ vpn.name }}/ca.crt
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 600
    - contents_pillar: openvpn:{{ vpn.name }}:shared:ca.crt
    - show_changes: false
    - require:
      - file: openvpn-keydir-{{ vpn.name }}
    - watch_in:
      - service: openvpn-client-{{ vpn.name }}-service

openvpn-tls-auth-key-{{ vpn.name }}:
  file.managed:
    - name: {{ openvpn_map.confdir }}/{{ openvpn_map.pkidir }}/{{ vpn.name }}/ta.key
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 600
    - contents_pillar: openvpn:{{ vpn.name }}:shared:ta.key
    - show_changes: false
    - require:
      - file: openvpn-keydir-{{ vpn.name }}
    - watch_in:
      - service: openvpn-client-{{ vpn.name }}-service

{% set common_name = grains['id'] %}

openvpn-client-cert-{{ vpn.name }}:
  file.managed:
    - name: {{ openvpn_map.confdir }}/{{ openvpn_map.pkidir }}/{{ vpn.name }}/client.crt
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 600
    - contents_pillar: openvpn:{{ vpn.name }}:client:client.crt
    - show_changes: false
    - require:
      - file: openvpn-keydir-{{ vpn.name }}
    - watch_in:
      - service: openvpn-client-{{ vpn.name }}-service

openvpn-client-key-{{ vpn.name }}:
  file.managed:
    - name: {{ openvpn_map.confdir }}/{{ openvpn_map.pkidir }}/{{ vpn.name }}/client.key
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 600
    - contents_pillar: openvpn:{{ vpn.name }}:client:client.key
    - show_changes: false
    - require:
      - file: openvpn-keydir-{{ vpn.name }}
    - watch_in:
      - service: openvpn-client-{{ vpn.name }}-service
{% endfor %}
