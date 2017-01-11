{% from 'states/gogs/map.jinja' import gogs as gogs_map with context %}

gogs:
  pkg.installed:
    - pkgs: {{ gogs_map.packages }}

  service.running:
    - name: {{ gogs_map.service }}
    - enable: true
    - require:
      - pkg: gogs
