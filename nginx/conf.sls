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

{% macro include_conf(name, include, context={}, include_states=[]) %}
{% set path = nginx_map.conf.include_dir + '/' + name + '.conf' %}
{% if include %}
nginx-{{ name }}.conf:
  file.managed:
    - name: {{ path }}
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 644
    - source: {{ 'salt://states/nginx/files/' + name + '.conf.jinja' }}
    - template: jinja
    - defaults: {{ context }}
    - require:
      - file: nginx-conf.d
    - watch_in:
      - service: nginx
{% else %}
nginx-{{ name }}.conf-absent:
  file.absent:
    - name: {{ path }}
    - watch_in:
      - service: nginx
{% endif %}

{% for state in include_states %}
include:
  - states.nginx.include.{{ state }}
{% endfor %}
{% endmacro %}

{% set name = '10_force_https' %}
{% set include = params.get('reverse_proxy', {}).get('protocol', []) == ['https'] %}
{% set context = {'ipv6': params.get('ipv6', False)} %}
{{ include_conf(name, include, context) }}

{% set name = '15_ssl' %}
{% set include =  'https' in params.get('reverse_proxy', {}).get('protocol', []) %}
{{ include_conf(name, include) }}

{% set name = '10_static_content' %}
{% set include = params.get('static_content', None) is not none %}
{% set context = {
  'content': params.get('static_content'),
  'ipv6': params.get('ipv6', False)} %}
{{ include_conf(name, include, context) }}

{% set name = '20_reverse_proxy' %}
{% set include = params.get('reverse_proxy', None) is not none %}
{% set context = {
  'upstream': params.get('reverse_proxy', {}).get('upstream'),
  'ipv6': params.get('ipv6', False),
  'protocol': params.get('reverse_proxy', {}).get('protocol')} %}
{{ include_conf(name, include, context) }}

{% set name = '30_cgi' %}
{% set include = params.get('cgi', None) is not none %}
{% set include_states = ['cgi'] %}
{% set context = {
  'protocols': params.get('protocols', ['http']),
  'ipv6': params.get('ipv6', False),
  'socket': params.cgi.socket,
  'cgi_params': params.cgi.params} %}
{{ include_conf(name, include, context, include_states) }}

{% set name = '30_local_status' %}
{% set include = True %}
{{ include_conf(name, include) }}
