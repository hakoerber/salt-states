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

{% set commoncert = false %}
{% for domain in params.domains %}
{% if domain.get('ssl_cert', false) %}
nginx-pkidir-{{ domain.name }}:
  file.directory:
    - name: {{ nginx_map.conf.confdir }}/{{ nginx_map.pki.pkidir }}/{{ domain.name }}
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 700
    - require:
      - file: nginx-pkidir

nginx-ssl-cert-{{ domain.name }}:
  file.managed:
    - name: {{ nginx_map.conf.confdir }}/{{ nginx_map.pki.pkidir }}/{{ domain.name }}/{{ nginx_map.pki.cert }}
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 600
    - source: salt://files/ssl/{{ grains['id'] }}/{{ domain.name }}/fullchain.pem
    - show_diff: false
    - require:
      - file: nginx-pkidir-{{ domain.name }}
    - watch_in:
      - service: nginx

nginx-ssl-key-{{ domain.name }}:
  file.managed:
    - name: {{ nginx_map.conf.confdir }}/{{ nginx_map.pki.pkidir }}/{{ domain.name }}/{{ nginx_map.pki.key }}
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 600
    - source: salt://files/ssl/{{ grains['id'] }}/{{ domain.name }}/privkey.pem
    - show_diff: false
    - require:
      - file: nginx-pkidir-{{ domain.name }}
    - watch_in:
      - service: nginx
{% else %}
{% set commoncert = true %}
{% endif %}
{% endfor %}

{% if commoncert %}
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
{% endif %}

{% set dhparams = nginx_map.conf.confdir + '/' + nginx_map.pki.pkidir + '/' + nginx_map.pki.dhparams %}
nginx-ssl-dhparams:
  file.managed:
    - name: {{ dhparams }}
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 600
    - require:
      - file: nginx-pkidir
    - watch_in:
      - service: nginx
{% if params.get('master_dhparams', false) == true %}
    - source: salt://files/ssl/{{ grains['id'] }}/dhparams.pem
    - show_diff: false
{% else %}
    - require:
      - cmd: nginx-ssl-dhparams-create

nginx-ssl-dhparams-create:
  cmd.run:
    - name: openssl dhparam -out {{ dhparams }} {{ nginx_map.pki.dh_bits }}
    - user: root
    - group: {{ defaults.rootgroup }}
    - creates: {{ dhparams }}
    - require:
      - file: nginx-pkidir
    - watch_in:
      - service: nginx
{% endif %}
