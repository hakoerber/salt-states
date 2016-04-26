{% from 'states/rsyslog/map.jinja' import rsyslog as rsyslog_map with context %}
{% from 'states/owncloud/map.jinja' import owncloud as owncloud_map with context %}

owncloud-log:
  file.accumulated:
    - filename: {{ rsyslog_map.include_basedir }}/{{ rsyslog_map.applications_conf }}
    - text:
      - {{ owncloud_map.logging }}
    - require_in:
      - file: rsyslog-applications

owncloud-logfile:
  file.managed:
    - name: {{ owncloud_map.logging.file }}
    - user: {{ owncloud_map.logging.permissions.user }}
    - group: {{ owncloud_map.logging.permissions.group }}
    - mode: {{ owncloud_map.logging.permissions.mode }}
    - require_in:
      - file: owncloud-log
    - watch_in:
      - service: owncloud
