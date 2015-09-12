#!stateconf
{% from 'states/rsyslog/map.jinja' import rsyslog as rsyslog_map with context %}
{% from 'states/defaults.map.jinja' import defaults with context %}

.params:
    stateconf.set: []
# --- end of state config ---

{% if params.local %}
{% set filename = 'local.conf' %}
rsyslog_{{ filename }}:
  file.managed:
    - name: {{ rsyslog_map.include_basedir }}/{{ filename }}
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 644
    - source: salt://states/rsyslog/files/local.conf.jinja
    - template: jinja
    - require:
      - pkg: rsyslog
      - file: rsyslog.d
    - watch_in:
      - service: rsyslog
{% endif %}

{% for server in params.servers %}
{% set fqdn = server.name + "." + server.domain %}
{% for listener in server.listeners %}
{% set protocol = listener.protocol %}
{% set port = listener.port %}
{% set filename = 'forward_' + fqdn + '_' + protocol + '_' + port|string + '.conf' %}
rsyslog_{{ filename }}:
  file.managed:
    - name: {{ rsyslog_map.include_basedir }}/{{ filename }}
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 644
    - source: salt://states/rsyslog/files/forward.conf.jinja
    - template: jinja
    - defaults:
        target: {{ fqdn }}
        port: {{ port }}
        protocol: {{ protocol }}
    - require:
      - pkg: rsyslog
      - file: rsyslog.d
    - watch_in:
      - service: rsyslog
{% endfor %}
{% endfor %}
