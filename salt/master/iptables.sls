{% from 'states/salt/map.jinja' import salt as salt_map with context %}

{% for component, ports in salt_map.master.ports.items() %}
salt-master-iptables-{{ component }}:
  iptables.append:
    - table: filter
    - chain: ZONE_LOCAL
    - proto: tcp
    - jump: ACCEPT
    - dports: {{ ports }}
    - family: ipv4
    - save: true
    - match: comment
    - comment: salt master {{ component }}
    - require:
      - iptables: chain_zone_local_ipv4
{% endfor %}
