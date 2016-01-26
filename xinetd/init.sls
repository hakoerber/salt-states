{% from 'states/xinetd/map.jinja' import xinetd as xinetd_map with context %}

xinetd:
  pkg.installed:
    - pkgs: {{ xinetd_map.packages }}

  service.running:
    - name: {{ xinetd_map.service }}
    - enable: true
    - require:
      - pkg: xinetd

