{% from 'states/salt/map.jinja' import salt as salt_map with context %}

salt-master-iptables:
  iptables.append:
    - table: filter
    - chain: ZONE_LOCAL
    - proto: tcp
    - jump: ACCEPT
    - dports: {{ salt_map.master.ports }}
    - family: ipv4
    - save: true
    - match: comment
    - comment: salt-master
    - require:
      - iptables: chain_zone_local_ipv4

