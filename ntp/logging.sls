{% from 'states/rsyslog/map.jinja' import rsyslog as rsyslog_map with context %}
{% from 'states/ntp/map.jinja' import ntp as ntp_map with context %}

ntp-log:
  file.accumulated:
    - filename: {{ rsyslog_map.include_basedir }}/{{ rsyslog_map.applications_conf }}
    - text:
      - {{ ntp_map.logging }}
    - require_in:
      - file: rsyslog-applications
