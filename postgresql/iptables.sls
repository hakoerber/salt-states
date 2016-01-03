#!stateconf
{% from 'states/postgresql/map.jinja' import postgresql as postgresql_map with context %}

include:
  - states.templates.iptables

extend:
  states.templates.iptables::params:
    stateconf.set:
      - app: postgresql-server
      - ipv6: False
      - public: False
      - ports: {{ postgresql_map.ports }}
