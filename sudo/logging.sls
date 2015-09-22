{% from 'states/rsyslog/map.jinja' import rsyslog as rsyslog_map with context %}
{% from 'states/sudo/map.jinja' import sudo as sudo_map with context %}

sudo-log:
  file.accumulated:
    - filename: {{ rsyslog_map.include_basedir }}/{{ rsyslog_map.applications_conf }}
    - text:
      - {{ sudo_map.logging }}
    - require_in:
      - file: rsyslog-applications
