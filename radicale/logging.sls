{% from 'states/rsyslog/map.jinja' import rsyslog as rsyslog_map with context %}
{% from 'states/radicale/map.jinja' import radicale as radicale_map with context %}

radicale-log:
  file.accumulated:
    - filename: {{ rsyslog_map.include_basedir }}/{{ rsyslog_map.applications_conf }}
    - text:
      - {{ radicale_map.logging }}
    - require_in:
      - file: rsyslog-applications
