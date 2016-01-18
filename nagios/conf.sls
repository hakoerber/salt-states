{% from 'states/nagios/map.jinja' import nagios as nagios_map with context %}
{% from 'states/defaults.map.jinja' import defaults with context %}

nagios.cfg:
  file.managed:
    - name: {{ nagios_map.conf }}
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 644
    - source: salt://states/nagios/files/nagios.cfg.jinja
    - template: jinja
    - require:
      - pkg: nagios
    - watch_in:
      - service: nagios
