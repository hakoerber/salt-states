{% from 'states/quassel/map.jinja' import quassel as quassel_map with context %}
{% from 'states/defaults.map.jinja' import defaults with context %}

quassel-conf:
  file.managed:
    - name: {{ quassel_map.core.conf_file }}
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 644
    - source: salt://states/quassel/files/quasselcore.jinja
    - template: jinja
    - watch_in:
      - service: quassel-core
    - require_in:
      - service: quassel-core
