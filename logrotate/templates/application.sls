{% from 'states/logrotate/map.jinja' import logrotate as logrotate_map with context %}
{% from 'states/defaults.map.jinja' import defaults with context %}

{{ application }}-logrotate:
  file.managed:
    - name: {{ logrotate_map.conf_dir }}/{{ logging.get('name', application) }}
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 644
    - source: {{ logrotate_map.application_template }}
    - template: jinja
    - defaults:
        logging: {{ logging }}
        application: {{ application }}
    - require:
      - pkg: logrotate
      - file: logrotate.d
