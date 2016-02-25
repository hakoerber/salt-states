#!stateconf
{% from 'states/dhcpd/map.jinja' import dhcpd as dhcpd_map with context %}
{% from 'states/defaults.map.jinja' import defaults with context %}
{% set conf_template = 'salt://states/dhcpd/files/dhcpd.conf.jinja' %}

.params:
    stateconf.set: []
# --- end of state config ---

# parameters:
# 

dhcpd.conf:
  file.managed:
    - name: {{ dhcpd_map.conf_file }}
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 644
    - source: {{ conf_template }}
    - template: jinja
    - require:
      - pkg: dhcpd
    - watch_in:
      - service: dhcpd
    - defaults:
        params: {{ params }}
