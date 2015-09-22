#!stateconf
{% from 'states/rsyslog/map.jinja' import rsyslog as rsyslog_map with context %}
{% from 'states/defaults.map.jinja' import defaults with context %}

.params:
    stateconf.set: []
# --- end of state config ---

rsyslog-applications:
  file.managed:
    - name: {{ rsyslog_map.include_basedir }}/{{ rsyslog_map.applications_conf }}
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 644
    - source: salt://states/rsyslog/files/application.conf.jinja
    - template: jinja
    - require:
      - pkg: rsyslog
      - file: rsyslog.d
    - watch_in:
      - service: rsyslog
