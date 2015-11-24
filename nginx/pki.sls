#!stateconf
{% from 'states/nginx/map.jinja' import nginx as nginx_map with context %}
{% from 'states/defaults.map.jinja' import defaults with context %}

.params:
    stateconf.set: []
# --- end of state config ---

nginx-pkidir:
  file.directory:
    - name: {{ nginx_map.conf.confdir }}/{{ nginx_map.pki.pkidir }}
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 700
    - require:
      - pkg: nginx

nginx-ssl-cert:
  file.managed:
    - name: {{ nginx_map.conf.confdir }}/{{ nginx_map.pki.pkidir }}/{{ nginx_map.pki.cert }}
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 600
    - source: salt://files/ssl/{{ grains['id'] }}/fullchain.pem
    - show_diff: false
    - require:
      - file: nginx-pkidir
    - watch_in:
      - service: nginx

nginx-ssl-key:
  file.managed:
    - name: {{ nginx_map.conf.confdir }}/{{ nginx_map.pki.pkidir }}/{{ nginx_map.pki.key }}
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 600
    - source: salt://files/ssl/{{ grains['id'] }}/privkey.pem
    - show_diff: false
    - require:
      - file: nginx-pkidir
    - watch_in:
      - service: nginx

nginx-ssl-dhparams:
  file.managed:
    - name: {{ nginx_map.conf.confdir }}/{{ nginx_map.pki.pkidir }}/{{ nginx_map.pki.dhparams }}
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 600
    - source: salt://files/ssl/{{ grains['id'] }}/dhparams.pem
    - show_diff: false
    - require:
      - file: nginx-pkidir
    - watch_in:
      - service: nginx
