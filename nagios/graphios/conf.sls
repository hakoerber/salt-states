#!stateconf
{% from 'states/nagios/map.jinja' import nagios as nagios_map with context %}
{% from 'states/defaults.map.jinja' import defaults with context %}

.params:
    stateconf.set: []
# --- end of state config ---

graphios-nagios-conf:
  file.accumulated:
    - filename: {{ nagios_map.conf }}
    - text:
      - host_perfdata_file_template: DATATYPE::HOSTPERFDATA\tTIMET::$TIMET$\tHOSTNAME::$HOSTNAME$\tHOSTPERFDATA::$HOSTPERFDATA$\tHOSTCHECKCOMMAND::$HOSTCHECKCOMMAND$\tHOSTSTATE::$HOSTSTATE$\tHOSTSTATETYPE::$HOSTSTATETYPE$\tGRAPHITEPREFIX::$_HOSTGRAPHITEPREFIX$\tGRAPHITEPOSTFIX::$_HOSTGRAPHITEPOSTFIX$
        service_perfdata_file: {{ nagios_map.graphios.spooldir }}/service-perfdata
        host_perfdata_file_mode: a
        service_perfdata_file_template: DATATYPE::SERVICEPERFDATA\tTIMET::$TIMET$\tHOSTNAME::$HOSTNAME$\tSERVICEDESC::$SERVICEDESC$\tSERVICEPERFDATA::$SERVICEPERFDATA$\tSERVICECHECKCOMMAND::$SERVICECHECKCOMMAND$\tHOSTSTATE::$HOSTSTATE$\tHOSTSTATETYPE::$HOSTSTATETYPE$\tSERVICESTATE::$SERVICESTATE$\tSERVICESTATETYPE::$SERVICESTATETYPE$\tGRAPHITEPREFIX::$_SERVICEGRAPHITEPREFIX$\tGRAPHITEPOSTFIX::$_SERVICEGRAPHITEPOSTFIX$
        host_perfdata_file_processing_command: graphite_perf_host
        host_perfdata_file: {{ nagios_map.graphios.spooldir }}/host-perfdata
        service_perfdata_file_mode: a
        service_perfdata_file_processing_interval: 15
        host_perfdata_file_processing_interval: 15
        service_perfdata_file_processing_command: graphite_perf_service
    - require:
      - file: graphios-spooldir
      - pkg: graphios
    - require_in:
      - file: nagios.cfg
    - watch_in:
      - service: nagios

graphios.cfg:
  file.managed:
    - name: {{ nagios_map.graphios.conf }}
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 600
    - source: salt://states/nagios/files/graphios.cfg.jinja
    - template: jinja
    - defaults:
        influxdb: {{ params.influxdb }}
    - require:
      - file: graphios-spooldir
      - pkg: graphios
    - watch_in:
      - service: graphios

graphios-spooldir:
  file.directory:
    - name: {{ nagios_map.graphios.spooldir }}
    - user: {{ nagios_map.user }}
    - group: {{ nagios_map.group }}
    - mode: 700
    - require:
      - pkg: nagios
    - watch_in:
      - service: nagios
      - service: graphios

graphios-commands.cfg:
  file.managed:
    - name: {{ nagios_map.confdir }}/{{ nagios_map.graphios.graphios_commands }}
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 644
    - source: salt://states/nagios/files/graphios_commands.cfg.jinja
    - template: jinja
    - require:
      - file: graphios-spooldir
      - pkg: graphios
      - pkg: nagios
    - watch_in:
      - service: nagios

graphios.mk:
  file.managed:
    - name: {{ nagios_map.check_mk.server.confdir }}/{{ nagios_map.graphios.check_mk_conf }}
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 644
    - source: salt://states/nagios/files/graphios.mk
    - template: jinja
    - require:
      - pkg: graphios
      - pkg: check_mk-server
      - file: main.mk
    - onchanges_in:
      - cmd: check_mk-update
