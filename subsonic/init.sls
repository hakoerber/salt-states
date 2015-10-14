{% from "subsonic/map.jinja" import subsonic as subsonic_map with context %}

subsonic:
  service.running:
    - name: {{ subsonic_map.service }}
    - enable: true
