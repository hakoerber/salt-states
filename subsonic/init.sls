{% from "states/subsonic/map.jinja" import subsonic as subsonic_map with context %}

subsonic:
  pkg.installed:
    - pkgs: {{ subsonic_map.packages }}

  service.running:
    - name: {{ subsonic_map.service }}
    - enable: true
    - require:
      - pkg: subsonic
