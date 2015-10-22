#!stateconf
{% from 'states/rsyslog/map.jinja' import rsyslog as rsyslog_map with context %}
{% from 'states/defaults.map.jinja' import defaults with context %}

.params:
    stateconf.set: []
# --- end of state config ---

{% set filename = '20_local.conf' %}
rsyslog_{{ filename }}:
  file.managed:
    - name: {{ rsyslog_map.include_basedir }}/{{ filename }}
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 644
    - source: salt://states/rsyslog/files/{{ filename }}.jinja
    - template: jinja
    - makedirs: True
    - require:
      - pkg: rsyslog
    - watch_in:
      - service: rsyslog

{% set filename = '30_forward.conf' %}
rsyslog_{{ filename }}:
  file.managed:
    - name: {{ rsyslog_map.include_basedir }}/{{ filename }}
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 644
    - source: salt://states/rsyslog/files/{{ filename }}.jinja
    - template: jinja
    - makedirs: True
    - defaults:
        servers: {{ params.servers }}
    - require:
      - pkg: rsyslog
    - watch_in:
      - service: rsyslog
