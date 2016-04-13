{% from 'states/dovecot/map.jinja' import dovecot as dovecot_map with context %}
{% from 'states/defaults.map.jinja' import defaults with context %}

dovecot-ssl-certs:
  cmd.run:
    - name: openssl req -batch -x509 -nodes -days 3650 -newkey rsa:2048 -keyout {{ dovecot_map.pkidir }}/{{ dovecot_map.pki.key }} -out {{ dovecot_map.pkidir }}/{{ dovecot_map.pki.cert }}
    - user: root
    - group: {{ defaults.rootgroup }}
    - umask: 377
    - creates: {{ dovecot_map.pkidir }}/{{ dovecot_map.pki.cert }}
    - creates: {{ dovecot_map.pkidir }}/{{ dovecot_map.pki.key }}
    - require_in:
      - file: dovecot.conf
    - require:
      - file: dovecot-pkidir
    - watch_in:
      - service: dovecot

dovecot-pkidir:
  file.directory:
    - name: {{ dovecot_map.pkidir }}
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 700
