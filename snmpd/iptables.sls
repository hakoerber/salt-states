#!stateconf
{% from 'states/snmpd/map.jinja' import snmpd as snmpd_map with context %}

include:
  - states.templates.iptables

extend:
  states.templates.iptables::params:
    stateconf.set:
      - app: snmpd
      - ipv6: False
      - public: False
      - ports: {{ snmpd_map.ports }}
