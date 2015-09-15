#!stateconf
{% from 'states/nagios/map.jinja' import nagios as nagios_map with context %}
{% from 'states/defaults.map.jinja' import defaults with context %}

.params:
    stateconf.set: []
# --- end of state config ---

{% set port = params.get('port', nagios_map.check_mk.agent.port) %}

{% if grains['os_family'] == 'FreeBSD' %}
check-mk-agent-hosts-allow:
  file.blockreplace:
    - name: {{ nagios_map.check_mk.agent.conf.hosts_allow.path }}
    - marker_start: '# START managed zone check_mk'
    - marker_end: '# END managed zone check_mk'
    - content: |
       check_mk_agent : {{ params.servers|map(attribute='ip')|join(',') }} : allow
       check_mk_agent : ALL : deny
    - append_if_not_found: True
    - show_changes: True
    - watch_in:
      - service: check_mk-agent


check-mk-agent-services:
  file.append:
    - name: {{ nagios_map.check_mk.agent.conf.services.path }}
    - text:
      - "check_mk {{ port }}/tcp #check_mk agent"
    - watch_in:
      - service: check_mk-agent

check-mk-agent-inetd.conf:
  file.append:
    - name: {{ nagios_map.check_mk.agent.conf.inetd.path }}
    - text:
      - "check_mk stream tcp nowait root {{ nagios_map.check_mk.agent.script.path }} check_mk_agent"
    - watch_in:
      - service: check_mk-agent
    - require:
      - file: check-mk-agent-services
      - file: check-mk-agent-hosts-allow

{% else %}
check_mk-agent-xinetd-conf:
  file.managed:
    - name: {{ nagios_map.check_mk.agent.conf.xinetd.path }}
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 644
    - source: {{ nagios_map.check_mk.agent.conf.xinetd.template }}
    - template: jinja
    - require:
      - pkg: check_mk-agent
    - watch_in:
      - service: check_mk-agent
    - context:
        servers: {{ params.servers }}
        port: {{ port }}
{% endif %}
