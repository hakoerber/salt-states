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

reload_zones:
  cmd.wait:
    - name: rndc reload

{% if params.role == 'master' %}
zone-{{ params.domain }}-forward:
  file.managed:
    - name: {{ bind_map.main_directory }}/forward.{{ params.domain }}
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 644
    - source: 'salt://states/bind/files/forward.zone.jinja'
    - template: jinja
    - defaults:
        params: {{ params }}
    - require:
      - pkg: bind
    - require_in:
      - file: named.conf
    - watch_in:
      - cmd: reload_zones

zone-{{ params.domain }}-reverse:
  file.managed:
    - name: {{ bind_map.main_directory }}/reverse.{{ params.domain }}
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 644
    - source: 'salt://states/bind/files/reverse.zone.jinja'
    - template: jinja
    - defaults:
        params: {{ params }}
    - require:
      - pkg: bind
    - require_in:
      - file: named.conf
    - watch_in:
      - cmd: reload_zones
{% endif %}
