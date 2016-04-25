{% from "states/cobbler/map.jinja" import cobbler as cobbler_map with context %}
{% from 'states/defaults.map.jinja' import defaults with context %}

cobbler:
  pkg.installed:
    - pkgs: {{ cobbler_map.packages }}

  service.running:
    - name: {{ cobbler_map.service }}
    - enable: true
    - require:
      - pkg: cobbler

cobbler-sync:
  cmd.run:
    - name: 'sleep 1 ; cobbler sync'
    - user: root
    - group: {{ defaults.rootgroup }}
    - onchanges:
      - service: cobbler
