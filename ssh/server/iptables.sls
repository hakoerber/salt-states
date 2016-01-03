#!stateconf
{% from 'states/ssh/map.jinja' import ssh as ssh_map with context %}

include:
  - states.templates.iptables

extend:
  states.templates.iptables::params:
    stateconf.set:
      - app: ssh-server
      - ipv6: True
      - public: True
      - ports: {{ ssh_map.server.ports }}
