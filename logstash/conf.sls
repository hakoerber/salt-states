#!stateconf
{% from 'states/logstash/map.jinja' import logstash as logstash_map with context %}
{% from 'states/defaults.map.jinja' import defaults with context %}
{% from 'states/logstash/applications.jinja' import applications %}

.params:
    stateconf.set: []
# --- end of state config ---

logstash-conf.d:
  file.recurse:
    - name: {{ logstash_map.confdir }}
    - user: root
    - group: {{ defaults.rootgroup }}
    - file_mode: 644
    - dir_mode: 755
    - clean: True
    - source: salt://states/logstash/files/conf.d
    - template: jinja
    - defaults:
        params: {{ params }}
        applications: {{ applications }}
    - require:
      - pkg: logstash
    - watch_in:
      - service: logstash

logstash-patterns.d:
  file.recurse:
    - name: {{ logstash_map.patternsdir }}
    - user: root
    - group: {{ defaults.rootgroup }}
    - file_mode: 644
    - dir_mode: 755
    - clean: True
    - source: salt://states/logstash/files/patterns.d
    - require:
      - pkg: logstash
    - watch_in:
      - service: logstash
