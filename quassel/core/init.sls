{% from "states/quassel/map.jinja" import quassel as quassel_map with context %}
{% from 'states/defaults.map.jinja' import defaults with context %}

quassel-core:
  pkg.installed:
    - pkgs: {{ quassel_map.core.packages }}

  service.running:
    - name: {{ quassel_map.core.service }}
    - enable: true
    - require:
      - pkg: quassel-core

  user.present:
    - name: {{ quassel_map.core.user }}
    - system: True
    - home: {{ quassel_map.core.datadir }}
    - gid_from_name: True
    - shell: {{ defaults.nologin }}
    - require_in:
      - service: quassel-core

quassel-systemd:
  file.managed:
    - name: {{ quassel_map.core.systemd_file }}
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 644
    - source: salt://states/quassel/files/quassel.service
    - watch_in:
      - service: quassel-core

systemd-daemon-reload:
  cmd.run:
    - name: systemctl daemon-reload
    - user: root
    - group: {{ defaults.rootgroup }}
    - onchanges:
      - file: quassel-systemd
    - require_in:
      - service: quassel-core
