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
      {% for file in rsyslog_map.client.include %}
      - file: {{ rsyslog_map.include_basedir }}/{{ file.name }}
      {% endfor %}
