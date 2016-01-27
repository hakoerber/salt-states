{% from 'states/thruk/map.jinja' import thruk as thruk_map with context %}

thruk:
  pkg.installed:
    - name: {{ thruk_map.package }}

  service.running:
    - name: {{ thruk_map.service }}
    - enable: true
    - require:
      - pkg: thruk
      - service: thruk-webserver

thruk-webserver:
  service.running:
    - name: {{ thruk_map.service_webserver }}
    - enable: true
    - require:
      - pkg: thruk
