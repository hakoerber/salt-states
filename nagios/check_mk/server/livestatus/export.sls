{% from 'states/nagios/map.jinja' import nagios as nagios_map with context %}
{% from 'states/defaults.map.jinja' import defaults with context %}

xinetd:
  pkg.installed:
    - pkg: {{ nagios_map.xinetd.package }}

  service.running:
    - name: {{ nagios_map.xinetd.service }}
    - enable: true
    - require:
      - pkg: xinetd

livestatus-xinetd.conf:
  file.managed:
    - name: /etc/xinetd.d/livestatus
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 644
    - source: salt://states/nagios/files/livestatus.xinetd.jinja
    - template: jinja
    - require:
      - pkg: xinetd
      - pkg: check_mk-server-livestatus
    - watch_in:
      - service: xinetd
