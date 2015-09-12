#!stateconf

.params:
    stateconf.set: []
# --- end of state config ---

{# currently no support for ipv6 zones #}
{% set families = ['ipv4'] %}

{% set zones = {
    'public': {
      'source': '0.0.0.0/0',
    },
  }
%}
{% do zones.update(params.zones) %}

{% for zone, zoneinfo in zones.items() %}
{% set zonechain = "ZONE_" ~ zone|upper %}

{% for family in families %}
chain_zone_{{ zone }}_{{ family }}:
  iptables.chain_present:
    - name: {{ zonechain }}
    - family: {{ family }}

tcp_jump_to_zone_{{ zone }}_{{ family }}:
  iptables.append:
    - table: filter
    - chain: TCPUDP
    - jump: {{ zonechain }}
    - family: {{ family }}
    - proto: tcp
    - tcp-flags: SYN,RST,ACK,FIN SYN
    - source: {{ zoneinfo.source }}
    - match: state
    - connstate: NEW
    - save: true
    - require:
      - iptables: chain_zone_{{ zone }}_{{ family }}
      - iptables: chain_tcpudp_{{ family }}

udp_jump_to_zone_{{ zone }}_{{ family }}:
  iptables.append:
    - table: filter
    - chain: TCPUDP
    - jump: {{ zonechain }}
    - family: {{ family }}
    - proto: udp
    - source: {{ zoneinfo.source }}
    - match: state
    - connstate: NEW
    - save: true
    - require:
      - iptables: chain_zone_{{ zone }}_{{ family }}
      - iptables: chain_tcpudp_{{ family }}
{% endfor %}
{% endfor %}
