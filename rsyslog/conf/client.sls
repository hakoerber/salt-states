#!stateconf
{% from 'states/rsyslog/map.jinja' import rsyslog as rsyslog_map with context %}
{% from 'states/defaults.map.jinja' import defaults with context %}

.params:
    stateconf.set: []
# --- end of state config ---

{% if params.local %}
{% set filename = '20_local.conf' %}
rsyslog_{{ filename }}:
  file.managed:
    - name: {{ rsyslog_map.include_basedir }}/{{ filename }}
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 644
    - source: salt://states/rsyslog/files/{{ filename }}.jinja
    - template: jinja
    - require:
      - pkg: rsyslog
      - file: rsyslog.d
    - watch_in:
      - service: rsyslog
{% endif %}

{% set filename = '30_forward.conf' %}
rsyslog_{{ filename }}:
  file.managed:
    - name: {{ rsyslog_map.include_basedir }}/{{ filename }}
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 644
    - source: salt://states/rsyslog/files/{{ filename }}.jinja
    - template: jinja
    - defaults:
        servers: {{ params.servers }}
    - require:
      - pkg: rsyslog
      - file: rsyslog.d
    - watch_in:
      - service: rsyslog
