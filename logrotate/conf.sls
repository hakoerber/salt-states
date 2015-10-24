{% from 'states/logrotate/map.jinja' import logrotate as logrotate_map with context %}
{% from 'states/defaults.map.jinja' import defaults with context %}

logrotate.conf:
  file.managed:
    - name: {{ logrotate_map.conf_file }}
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 644
    - source: 'salt://states/logrotate/files/logrotate.conf.jinja'
    - template: jinja
    - require:
      - pkg: logrotate
      - file: logrotate.d

logrotate.d:
  file.directory:
    - name: {{ logrotate_map.conf_dir }}
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 755

{% set logging = logrotate_map.default_logging %}
{% for application, logging in logrotate_map.default_logging.items() %}
{% include 'states/logrotate/templates/application.sls' with context %}
{% endfor %}
