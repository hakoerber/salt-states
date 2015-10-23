{% from 'states/logrotate/map.jinja' import logrotate as logrotate_map with context %}

logrotate:
  pkg.installed:
    - name: {{ logrotate_map.package }}
