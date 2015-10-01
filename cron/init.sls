{% from 'states/cron/map.jinja' import cron as cron_map with context %}

cron:
  pkg.installed:
    - pkgs: {{ cron_map.packages }}

  service.running:
    - name: {{ cron_map.service }}
    - enable: true
    - require:
      - pkg: cron
