{% from 'states/bind/map.jinja' import bind as bind_map with context %}

bind:
  pkg.removed:
    - name: {{ bind_map.package }}
    - require:
      - service: bind

  service.dead:
    - name: {{ bind_map.service }}
    - enable: false
