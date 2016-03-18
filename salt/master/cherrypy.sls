#!stateconf
{% from 'states/salt/map.jinja' import salt as salt_map with context %}
{% from 'states/defaults.map.jinja' import defaults with context %}

.params:
    stateconf.set: []
# --- end of state config ---

cherrypy:
  pkg.installed:
    - pkgs: {{ salt_map.master.cherrypy.packages }}

salt-cherrypy-conf:
  file.managed:
    - name: {{ salt_map.master.conf_dir }}/cherrypy.conf
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 640
    - source: salt://states/salt/files/cherrypy.conf.jinja
    - defaults:
        users: {{ params.users }}
    - template: jinja
    - watch_in:
      - service: salt-master
    - require:
      - pkg: cherrypy
      - module: salt-cherrypy-cert

salt-cherrypy-cert:
  module.run:
    - name: tls.create_self_signed_cert
    - CN: 'cherrypy'
    - cacert_path: {{ salt_map.master.cherrypy.cert_dir }}
    - tls_dir: ''
    - replace: false
    - unless:
      - test -e {{ salt_map.master.cherrypy.cert_dir }}/certs/cherrypy.crt
      - test -e {{ salt_map.master.cherrypy.cert_dir }}/certs/cherrypy.key

{% set application = 'salt-cherrypy' %}
{% set ipv6 = False %}
{% set public = False %}
{% set ports = {'tcp': [salt_map.master.cherrypy.port]} %}

{% include 'states/templates/iptables.sls.jinja' with context %}

{% for user in params.users %}
salt-cherrypy-user-{{ user.name }}:
  user.present:
    - name: {{ user.name }}
    - home: /var/lib/{{ user.name }}
    - password: {{ user.password }}
    - shell: {{ defaults.nologin }}
    - system: true
{% endfor %}
