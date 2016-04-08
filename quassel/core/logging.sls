{% from 'states/rsyslog/map.jinja' import rsyslog as rsyslog_map with context %}
{% from 'states/quassel/map.jinja' import quassel as quassel_map with context %}

quassel-log:
  file.accumulated:
    - filename: {{ rsyslog_map.include_basedir }}/{{ rsyslog_map.applications_conf }}
    - text:
      - {{ quassel_map.core.logging }}
    - require_in:
      - file: rsyslog-applications

quassel-log-exists:
  file.managed:
    - name: {{ quassel_map.core.logging.file }}
    - user: {{ quassel_map.core.logging.permissions.user }}
    - group: {{ quassel_map.core.logging.permissions.group }}
    - mode: {{ quassel_map.core.logging.permissions.mode }}
    - require_in:
      - service: quassel-core
      - file: quassel-log
