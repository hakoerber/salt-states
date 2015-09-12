{% from 'states/rsyslog/map.jinja' import rsyslog as rsyslog_map with context %}

rsyslog:
  pkg.installed:
    - name: {{ rsyslog_map.package }}

  service.running:
    - name: {{ rsyslog_map.service }}
    - enable: true
    - require:
      - pkg: rsyslog
