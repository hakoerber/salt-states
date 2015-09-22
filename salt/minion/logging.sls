{% from 'states/rsyslog/map.jinja' import rsyslog as rsyslog_map with context %}
{% from 'states/salt/map.jinja' import salt as salt_map with context %}

salt-minion-log:
  file.accumulated:
    - filename: {{ rsyslog_map.include_basedir }}/{{ rsyslog_map.applications_conf }}
    - text:
      - {{ salt_map.minion.logging }}
    - require_in:
      - file: rsyslog-applications
