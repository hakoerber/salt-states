{% from 'states/quassel/map.jinja' import quassel as quassel_map with context %}
{% from 'states/defaults.map.jinja' import defaults with context %}

quassel-ssl-certs:
  cmd.run:
    - name: openssl req -batch -x509 -nodes -days 3650 -newkey rsa:2048 -keyout {{ quassel_map.core.datadir }}/{{ quassel_map.core.pki.key }} -out {{ quassel_map.core.datadir }}/{{ quassel_map.core.pki.cert }}
    - user: {{ quassel_map.core.user }}
    - group: {{ quassel_map.core.user }}
    - umask: 077
    - creates: {{ quassel_map.core.datadir }}/{{ quassel_map.core.pki.cert }}
    - creates: {{ quassel_map.core.datadir }}/{{ quassel_map.core.pki.key }}
    - require_in:
      - file: quassel-conf
    - watch_in:
      - service: quassel-core
