{% from "states/cobbler/map.jinja" import cobbler as cobbler_map with context %}

cobbler:
  pkg.installed:
    - pkgs: {{ cobbler_map.packages }}

  service.running:
    - name: {{ cobbler_map.service }}
    - enable: true
    - require:
      - pkg: cobbler
