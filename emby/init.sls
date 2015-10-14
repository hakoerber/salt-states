{% from "states/emby/map.jinja" import emby as emby_map with context %}

emby:
  service.running:
    - name: {{ emby_map.service }}
    - enable: true
