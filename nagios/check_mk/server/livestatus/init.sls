{% from 'states/nagios/map.jinja' import nagios as nagios_map with context %}

check_mk-server-livestatus:
  pkg.installed:
    - name: {{ nagios_map.check_mk.server.livestatus.package }}
    - require:
      - pkg: check_mk-server

check_mk-server-livestatus-conf:
  file.accumulated:
    - filename: {{ nagios_map.conf }}
    - text:
      - event_broker_options: "-1"
      - broker_module: "{{ nagios_map.check_mk.server.livestatus.module_path }} {{ nagios_map.socket_dir }}/{{ nagios_map.check_mk.server.livestatus.socket_name }}"
    - require:
      - pkg: check_mk-server-livestatus
      - file: nagios-socketdir
    - require_in:
      - file: nagios.cfg
