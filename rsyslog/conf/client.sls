#!stateconf
{% from 'states/rsyslog/map.jinja' import rsyslog as rsyslog_map with context %}
{% from 'states/defaults.map.jinja' import defaults with context %}

.params:
    stateconf.set: []
# --- end of state config ---

{% for file in rsyslog_map.client.include %}
rsyslog-{{ file.tag }}:
  file.managed:
    - name: {{ rsyslog_map.include_basedir }}/{{ file.name }}
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 644
    - source: salt://states/rsyslog/files/{{ file.name }}.jinja
    - defaults:
        servers: {{ params.servers }}
    - template: jinja
    - makedirs: True
    - require:
      - pkg: rsyslog
    - watch_in:
      - service: rsyslog
{% endfor %}
