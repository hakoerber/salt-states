#!stateconf
{% from 'states/openvpn/map.jinja' import openvpn as openvpn_map with context %}
{% from 'states/defaults.map.jinja' import defaults with context %}

.params:
    stateconf.set: []
# --- end of state config ---

{% for vpn in params.vpns %}
openvpn-server-{{ vpn.name }}.conf:
  file.managed:
    - name: {{ openvpn_map.confdir }}/server-{{ vpn.name }}.conf
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 644
    - source: salt://states/openvpn/files/server.conf.jinja
    - template: jinja
    - defaults:
        vpn.name: {{ vpn.name }}
        vpn: {{ vpn }}
    - watch_in:
      - service: openvpn-server-{{ vpn.name }}-service
    - require:
      - pkg: openvpn
      - file: openvpn-server-{{ vpn.name }}-ccd

openvpn-server-{{ vpn.name }}-ccd:
  file.directory:
    - name: {{ openvpn_map.confdir }}/{{ vpn.name }}.ccd
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 755

{% for client in vpn.get('clients', {}) %}
{% set client_options = client.get('options', {}) %}
{% if client.options.get('ip', 'dhcp') != 'dhcp' or client.options.advertise_subnet is defined %}
openvpn-server-{{ vpn.name }}-ccd-{{ client.name }}:
  file.managed:
    - name: {{ openvpn_map.confdir }}/{{ vpn.name }}.ccd/{{ client.name }}
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 644
    - source: salt://states/openvpn/files/server.ccd.jinja
    - template: jinja
    - context:
        client_conf: {{ client_options }}
        vpn: {{ vpn }}
    - require:
      - file: openvpn-server-{{ vpn.name }}-ccd
{% endif %}
{% endfor %}

{% endfor %}
