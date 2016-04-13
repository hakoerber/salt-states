{% from 'states/dovecot/map.jinja' import dovecot as dovecot_map with context %}
{% from 'states/defaults.map.jinja' import defaults with context %}

dovecot:
  pkg.installed:
    - pkgs: {{ dovecot_map.packages }}

  service.running:
    - name: {{ dovecot_map.service }}
    - enable: true
    - require:
      - pkg: dovecot
