#!stateconf
{% from 'states/elasticsearch/map.jinja' import elasticsearch as elasticsearch_map with context %}
{% from 'states/defaults.map.jinja' import defaults with context %}

.params:
    stateconf.set: []
# --- end of state config ---

elasticsearch.yml:
  file.managed:
    - name: {{ elasticsearch_map.conf }}
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 644
    - source: salt://states/elasticsearch/files/elasticsearch.yml.jinja
    - template: jinja
    - defaults:
        params: {{ params }}
    - require:
      - pkg: elasticsearch
    - watch_in:
      - service: elasticsearch

