{% from 'states/rsyslog/map.jinja' import rsyslog as rsyslog_map with context %}
{% from 'states/ssh/map.jinja' import ssh as ssh_map with context %}

sshd-log:
  file.accumulated:
    - filename: {{ rsyslog_map.include_basedir }}/{{ rsyslog_map.applications_conf }}
    - text:
      - {{ ssh_map.server.logging }}
    - require_in:
      - file: rsyslog-applications
