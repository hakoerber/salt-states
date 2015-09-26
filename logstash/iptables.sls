#!stateconf
{% from 'states/logstash/map.jinja' import logstash as logstash_map with context %}

.params:
    stateconf.set: []
# --- end of state config ---

{% for listener in params.listeners %}
{% for family in ['ipv4'] %}
logstash-iptables-{{ listener.port }}-{{ listener.protocol }}-{{ family }}:
  iptables.append:
    - table: filter
    - chain: ZONE_LOCAL
    - proto: {{ listener.protocol }}
    - jump: ACCEPT
    - dport: {{ listener.port }}
    - family: {{ family }}
    - save: true
    - match: comment
    - comment: logstash {{ listener.format }}
    - require:
      - iptables: chain_zone_local_ipv4
{% endfor %}
{% endfor %}
