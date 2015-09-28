#!stateconf
{% from 'states/nginx/map.jinja' import nginx as nginx_map with context %}
{% from 'states/defaults.map.jinja' import defaults with context %}

.params:
    stateconf.set: []
# --- end of state config ---

nginx.conf:
  file.managed:
    - name: {{ nginx_map.conf.main.path }}
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 644
    - source: {{ nginx_map.conf.main.template }}
    - template: jinja
    - defaults:
        user: {{ params.get('user', nginx_map.user) }}
        group: {{ params.get('group', nginx_map.group) }}
    - require:
      - pkg: nginx
    - watch_in:
      - service: nginx

nginx-conf.d:
  file.directory:
    - name: {{ nginx_map.conf.include_dir }}
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 755
    - require:
      - pkg: nginx
    - require_in:
      - file: nginx.conf

{% set name = nginx_map.conf.include_dir + '/10_static_content.conf' %}
{% if params.get('static_content', None) is not none %}
nginx-10_static_content.conf:
  file.managed:
    - name: {{ name }}
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 644
    - source: 'salt://states/nginx/files/10_static_content.conf.jinja'
    - template: jinja
    - defaults:
        content: {{ params.static_content }}
    - require:
      - file: nginx-conf.d
    - watch_in:
      - service: nginx
{% else %}
nginx-10_static_content.conf-absent:
  file.absent:
    - name: {{ name }}
{% endif %}


{% set name = nginx_map.conf.include_dir + '/20_reverse_proxy.conf' %}
{% if params.get('reverse_proxy', None) is not none %}
nginx-20_reverse_proxy.conf:
  file.managed:
    - name: {{ nginx_map.conf.include_dir }}/20_reverse_proxy.conf
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 644
    - source: 'salt://states/nginx/files/20_reverse_proxy.conf.jinja'
    - template: jinja
    - defaults:
        reverse_proxy: {{ params.reverse_proxy }}
    - require:
      - file: nginx-conf.d
    - watch_in:
      - service: nginx
{% else %}
nginx-10_reverse-proxy.conf-absent:
  file.absent:
    - name: {{ name }}
{% endif %}
