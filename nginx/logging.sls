{% from 'states/rsyslog/map.jinja' import rsyslog as rsyslog_map with context %}
{% from 'states/nginx/map.jinja' import nginx as nginx_map with context %}

nginx-log:
  file.accumulated:
    - filename: {{ rsyslog_map.include_basedir }}/{{ rsyslog_map.applications_conf }}
    - text:
      - {{ nginx_map.logging }}
    - require_in:
      - file: rsyslog-applications
