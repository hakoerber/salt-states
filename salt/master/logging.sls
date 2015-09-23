{% from 'states/rsyslog/map.jinja' import rsyslog as rsyslog_map with context %}
{% from 'states/salt/map.jinja' import salt as salt_map with context %}

salt-master-log:
  file.accumulated:
    - filename: {{ rsyslog_map.include_basedir }}/{{ rsyslog_map.applications_conf }}
    - text:
      - {{ salt_map.master.logging }}
    - require_in:
      - file: rsyslog-applications

