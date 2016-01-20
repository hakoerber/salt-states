#!stateconf
{% from 'states/bind/map.jinja' import bind as bind_map with context %}
{% from 'states/defaults.map.jinja' import defaults with context %}

.params:
    stateconf.set: []
# --- end of state config ---

named.conf:
  file.managed:
    - name: {{ bind_map.conf_file }}
    - user: root
    - group: named
    - mode: 640
    - source: 'salt://states/bind/files/named.conf.jinja'
    - template: jinja
    - defaults:
        params: {{ params }}
    - require:
      - pkg: bind
      - file: named-logdir
    - watch_in:
      - service: bind

named-logdir:
  file.directory:
    - name: /var/log/named
    - user: named
    - group: named
    - mode: 700
