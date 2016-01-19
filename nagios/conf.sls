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

nagios-socketdir:
  file.directory:
    - name: {{ nagios_map.check_mk.server.livestatus.socket_dir }}
    - user: nagios
    - group: nagios
    - mode: 755
    - require_in:
      - file: nagios.cfg
    - watch_in:
      - service: nagios
