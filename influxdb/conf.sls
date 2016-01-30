#!stateconf
{% from 'states/influxdb/map.jinja' import influxdb as influxdb_map with context %}
{% from 'states/defaults.map.jinja' import defaults with context %}

.params:
    stateconf.set: []
# --- end of state config ---

influxdb.conf:
  file.managed:
    - name: {{ influxdb_map.conf }}
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 644
    - source: salt://states/influxdb/files/influxdb.conf.jinja
    - template: jinja
    - defaults:
        params: {{ params }}
    - require:
      - pkg: influxdb
    - watch_in:
      - service: influxdb

influxdb.env:
  file.managed:
    - name: {{ influxdb_map.envfile }}
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 644
    - source: salt://states/influxdb/files/influxdb.env.jinja
    - template: jinja
    - defaults:
        params: {{ params }}
    - require:
      - pkg: influxdb
    - watch_in:
      - service: influxdb
