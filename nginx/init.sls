{% from 'states/nginx/map.jinja' import nginx as nginx_map with context %}

nginx:
  pkg.installed:
    - name: {{ nginx_map.package }}

  service.running:
    - name: {{ nginx_map.service }}
    - enable: true
    - require:
      - pkg: nginx
