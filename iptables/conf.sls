{% set families = ['ipv4', 'ipv6'] %}

{% for family in families %}
chain_log_reject_{{ family }}:
  iptables.chain_present:
    - name: LOG_REJECT
    - family: {{ family }}

policy_allow_output_{{ family }}:
  iptables.set_policy:
    - table: filter
    - chain: OUTPUT
    - policy: ACCEPT
    - family: {{ family }}
    - save: true

policy_allow_input_{{ family }}:
  iptables.set_policy:
    - table: filter
    - chain: INPUT
    - policy: ACCEPT
    - family: {{ family }}
    - save: true

policy_drop_forward_{{ family }}:
  iptables.set_policy:
    - table: filter
    - chain: FORWARD
    - policy: DROP
    - family: {{ family }}
    - save: true

chain_tcpudp_{{ family }}:
  iptables.chain_present:
    - name: TCPUDP
    - family: {{ family }}

accept_loopback_{{ family }}:
  iptables.append:
    - table: filter
    - chain: INPUT
    - jump: ACCEPT
    - family: {{ family }}
    - in-interface: lo
    - save: true

accept_related_{{ family }}:
  iptables.append:
    - table: filter
    - chain: INPUT
    - jump: ACCEPT
    - family: {{ family }}
    - match: state
    - connstate: RELATED,ESTABLISHED
    - save: true

drop_invalid_{{ family }}:
  iptables.append:
    - table: filter
    - chain: INPUT
    - jump: DROP
    - family: {{ family }}
    - match: state
    - connstate: INVALID
    - save: true
{% endfor %}

accept_ping_ipv4:
  iptables.append:
    - table: filter
    - chain: INPUT
    - jump: ACCEPT
    - family: ipv4
    - proto: icmp
    - match: state
    - connstate: NEW
    - icmp-type: echo-request
    - save: true

accept_ping_ipv6:
  iptables.append:
    - table: filter
    - chain: INPUT
    - jump: ACCEPT
    - family: ipv6
    - proto: icmpv6
    - match: state
    - connstate: NEW
    - icmpv6-type: echo-request
    - save: true

accept_ndp_ipv6:
  iptables.append:
    - table: filter
    - chain: INPUT
    - jump: ACCEPT
    - family: ipv6
    - proto: icmpv6
    - source: fe80::/10
    - save: true

{% for family in families %}
tcp_jump_to_tcpudp_{{ family }}:
  iptables.append:
    - table: filter
    - chain: INPUT
    - jump: TCPUDP
    - family: {{ family }}
    - proto: tcp
    - tcp-flags: SYN,RST,ACK,FIN SYN
    - match: state
    - connstate: NEW
    - save: true

udp_jump_to_tcpudp_{{ family }}:
  iptables.append:
    - table: filter
    - chain: INPUT
    - jump: TCPUDP
    - family: {{ family }}
    - proto: udp
    - match: state
    - connstate: NEW
    - save: true

jump_to_log_reject_{{ family }}:
  iptables.append:
    - table: filter
    - chain: INPUT
    - jump: LOG_REJECT
    - family: {{ family }}
    - save: true
    - require:
      - iptables: chain_log_reject_{{ family }}

log_rejects_{{ family }}:
  iptables.append:
    - table: filter
    - chain: LOG_REJECT
    - match: limit
    - limit: 60/minute
    - limit-burst: 60
    - jump: LOG
    - log-prefix: '[iptables-reject] '
    - family: {{ family }}
    - save: true
    - require:
      - iptables: jump_to_log_reject_{{ family }}
{% endfor %}

reject_tcp_gracefully_ipv4:
  iptables.append:
    - table: filter
    - chain: INPUT
    - jump: REJECT
    - proto: tcp
    - family: ipv4
    - reject-with: tcp-reset
    - save: true

reject_tcp_gracefully_ipv6:
  iptables.append:
    - table: filter
    - chain: INPUT
    - jump: REJECT
    - proto: tcp
    - family: ipv6
    - reject-with: icmp6-adm-prohibited
    - save: true

reject_udp_gracefully_ipv4:
  iptables.append:
    - table: filter
    - chain: INPUT
    - jump: REJECT
    - proto: udp
    - family: ipv4
    - reject-with: icmp-port-unreachable
    - save: true

reject_udp_gracefully_ipv6:
  iptables.append:
    - table: filter
    - chain: INPUT
    - jump: REJECT
    - proto: udp
    - family: ipv6
    - reject-with: icmp6-adm-prohibited
    - save: true

{% for family in families %}
drop_everything_else_{{ family }}:
  iptables.append:
    - table: filter
    - chain: INPUT
    - jump: DROP
    - family: {{ family }}
    - save: true
{% endfor %}
