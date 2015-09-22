{% from 'states/rsyslog/map.jinja' import rsyslog as rsyslog_map with context %}
{% from 'states/iptables/map.jinja' import iptables as iptables_map with context %}

iptables-log:
  file.accumulated:
    - filename: {{ rsyslog_map.include_basedir }}/{{ rsyslog_map.applications_conf }}
    - text:
      - {{ iptables_map.logging }}
    - require_in:
      - file: rsyslog-applications
