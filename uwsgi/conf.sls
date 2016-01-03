#!stateconf
{% from 'states/uwsgi/map.jinja' import uwsgi as uwsgi_map with context %}
{% from 'states/defaults.map.jinja' import defaults with context %}

.params:
    stateconf.set: []
# --- end of state config ---

uwsgi-conf:
  file.managed:
    - name: {{ uwsgi_map.conf }}
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 644
    - source: {{ uwsgi_map.template }}
    - template: jinja
    - defaults:
      params: {{ params }}
    - require:
      - pkg: uwsgi
    - watch_in:
      - service: uwsgi
