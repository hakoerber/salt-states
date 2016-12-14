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
    - group: {{ elasticsearch_map.group }}
    - mode: 660
    - source: salt://states/elasticsearch/files/elasticsearch.yml.jinja
    - template: jinja
    - defaults:
        params: {{ params }}
    - require:
      - pkg: elasticsearch
    - watch_in:
      - service: elasticsearch

{% set memory_default = (grains.mem_total / 2)|int %}
{% set memory = params.get('memory', memory_default)|string %}

elasticsearch-jvm-config:
  file.managed:
    - name: {{ elasticsearch_map.jvm_config }}
    - user: root
    - group: {{ elasticsearch_map.group }}
    - mode: 660
    - source: salt://states/elasticsearch/files/jvm.options.jinja
    - template: jinja
    - defaults:
        memory: {{ memory }}
    - require:
      - pkg: elasticsearch
    - watch_in:
      - service: elasticsearch

elasticsearch-sysconfig:
  file.managed:
    - name: {{ elasticsearch_map.sysconfig }}
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 660
    - source: salt://states/elasticsearch/files/elasticsearch.sysconfig.jinja
    - template: jinja
    - require:
      - pkg: elasticsearch
    - watch_in:
      - service: elasticsearch

elasticsearch-systemd-override:
  file.managed:
    - name: {{ elasticsearch_map.systemd_override }}
    - user: root
    - group: {{ defaults.rootgroup }}
    - makedirs: True
    - mode: 644
    - source: salt://states/elasticsearch/files/elasticsearch.systemd.jinja
    - template: jinja
    - require:
      - pkg: elasticsearch
    - watch_in:
      - service: elasticsearch
    - onchanges_in:
      - cmd: elasticsearch-systemd-daemon-reload

elasticsearch-systemd-daemon-reload:
  cmd.run:
    - name: systemctl daemon-reload
    - user: root
    - group: {{ defaults.rootgroup }}
    - require_in:
      - service: elasticsearch

elasticsearch-systemd-security:
  file.managed:
    - name: {{ elasticsearch_map.security_limits }}
    - user: root
    - group: {{ defaults.rootgroup }}
    - makedirs: True
    - mode: 644
    - source: salt://states/elasticsearch/files/elasticsearch.limits.jinja
    - template: jinja
    - require:
      - pkg: elasticsearch
    - watch_in:
      - service: elasticsearch
