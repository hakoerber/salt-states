{% from "states/emby/map.jinja" import emby as emby_map with context %}

emby:
  pkg.installed:
    - pkgs: {{ emby_map.packages }}

  service.running:
    - name: {{ emby_map.service }}
    - enable: true
    - require:
      - pkg: emby
