{% from 'states/radicale/map.jinja' import radicale as radicale_map with context %}
{% from 'states/defaults.map.jinja' import defaults with context %}

radicale-config:
  file.managed:
    - name: {{ radicale_map.conf.main_file }}
    - user: {{ radicale_map.group }}
    - group: {{ radicale_map.group }}
    - mode: 640
    - source: salt://states/radicale/files/config.jinja
    - template: jinja
    - watch_in:
      - service: radicale

radicale-logging-config:
  file.managed:
    - name: {{ radicale_map.conf.logging_file }}
    - user: {{ radicale_map.group }}
    - group: {{ radicale_map.group }}
    - mode: 644
    - source: salt://states/radicale/files/logging.jinja
    - template: jinja
    - watch_in:
      - service: radicale
