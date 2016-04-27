{% from 'states/uwsgi/map.jinja' import uwsgi as uwsgi_map with context %}

uwsgi:
  pkg.installed:
    - pkgs: {{ uwsgi_map.packages }}

  service.running:
    - name: {{ uwsgi_map.service }}
    - enable: true
    - require:
      - pkg: uwsgi
