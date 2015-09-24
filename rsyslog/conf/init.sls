{% from 'states/rsyslog/map.jinja' import rsyslog as rsyslog_map with context %}
{% from 'states/defaults.map.jinja' import defaults with context %}

rsyslog.conf:
  file.managed:
    - name: {{ rsyslog_map.conf }}
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 644
    - source: salt://states/rsyslog/files/rsyslog.conf.jinja
    - template: jinja
    - require:
      - pkg: rsyslog
      - file: rsyslog.d
    - watch_in:
      - service: rsyslog

rsyslog.d:
  file.directory:
    - name: {{ rsyslog_map.include_basedir }}
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 755
    - clean: True
    - require:
      - file: /etc/rsyslog.d/40_applications.conf
      - file: /etc/rsyslog.d/20_local.conf
      - file: /etc/rsyslog.d/30_forward.conf
