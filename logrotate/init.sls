{% from 'states/logrotate/map.jinja' import logrotate as logrotate_map with context %}

logrotate:
  pkg.installed:
    - name: {{ logrotate_map.package }}

{# need to configure the cronjob manually for FreeBSD #}
{% if grains['os_family'] == 'FreeBSD' %}
logrotate-cronjob:
  cron.present:
    - name: {{ logrotate_map.binary }} {{ logrotate_map.conf_file }} >/dev/null 2>&1 || logger -t "logrotate" -p "cron.error" "Logrotate failed." >/dev/null 2>&1
    - user: root
    - minute: 0
    - hour: 0
    - comment: "logrotate"
    - identifier: "logrotate"
{% endif %}
