#!stateconf
{% from 'states/rsyslog/map.jinja' import rsyslog as rsyslog_map with context %}
{% from 'states/openvpn/map.jinja' import openvpn as openvpn_map with context %}

.params:
    stateconf.set: []
# --- end of state config ---

{% set files = [] %}
{% for vpn in params.vpns %}
{% do files.append({
  'path': '/var/log/openvpn-' + vpn.name + '.log',
  'tag': vpn.name
}) %}
{% endfor %}

openvpn-server-log:
  file.accumulated:
    - filename: {{ rsyslog_map.include_basedir }}/{{ rsyslog_map.applications_conf }}
    - text:
      - files: {{ files }}
    - require_in:
      - file: rsyslog-applications
