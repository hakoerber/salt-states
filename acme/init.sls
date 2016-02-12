{% from 'states/acme/map.jinja' import acme as acme_map with context %}

acme:
  pkg.installed:
    - name: {{ acme_map.package }}
