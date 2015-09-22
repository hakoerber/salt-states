{% from 'states/rsyslog/map.jinja' import rsyslog as rsyslog_map with context %}
{% from 'states/dhcpd/map.jinja' import dhcpd as dhcpd_map with context %}

dhcpd-log:
  file.accumulated:
    - filename: {{ rsyslog_map.include_basedir }}/{{ rsyslog_map.applications_conf }}
    - text:
      - {{ dhcpd_map.logging }}
    - require_in:
      - file: rsyslog-applications
