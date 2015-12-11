{% from 'states/firewalld/map.jinja' import firewalld as firewalld_map with context %}

firewalld:
  pkg.installed:
    - pkg: {{ firewalld_map.package }}

  service.running:
    - name: {{ firewalld_map.service }}
    - enable: true
    - require:
      - pkg: firewalld
