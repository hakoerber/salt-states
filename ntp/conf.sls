#!stateconf
{% from 'states/ntp/map.jinja' import ntp as ntp_map with context %}
{% from 'states/defaults.map.jinja' import defaults with context %}

.params:
    stateconf.set: []
# --- end of state config ---

ntp.conf:
  file.managed:
    - name: {{ ntp_map.conf_file }}
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 644
    - source: 'salt://states/ntp/files/ntp.conf.jinja'
    - template: jinja
    - defaults:
      params: {{ params }}
    - require:
      - pkg: ntp
    - watch_in:
      - service: ntp
