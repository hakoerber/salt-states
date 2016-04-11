{% from 'states/radicale/map.jinja' import radicale as radicale_map with context %}
{% from 'states/defaults.map.jinja' import defaults with context %}

radicale:
  pkg.installed:
    - pkgs: {{ radicale_map.packages }}

  service.running:
    - name: {{ radicale_map.service }}
    - enable: true
    - require:
      - pkg: radicale
