#!stateconf

.params:
    stateconf.set: []
# --- end of state config ---

{# currently no support for ipv6 zones #}
{% set families = ['ipv4', 'ipv6'] %}

{% for zone, zoneinfo in params.zones.items() %}
{% set zonechain = "ZONE_" ~ zone|upper %}

{% for family in families %}

{% if family == 'ipv6' %}
{% if zonechain != 'ZONE_PUBLIC' %}
{% continue %}
{% endif %}
{% endif %}

chain_zone_{{ zone }}_{{ family }}:
  iptables.chain_present:
    - name: {{ zonechain }}
    - family: {{ family }}

{% set sourceid = 0 %}
{% for source in zoneinfo.sources %}
{% set sourceid = sourceid + 1 %}

jump_to_zone_{{ zone }}_{{ family }}_source_{{ sourceid }}:
  iptables.append:
    - table: filter
    - chain: TCPUDP
    - jump: {{ zonechain }}
    - family: {{ family }}
    - source: {{ source }}
    - save: true
    - require:
      - iptables: chain_zone_{{ zone }}_{{ family }}
      - iptables: chain_tcpudp_{{ family }}

{% endfor %}
{% endfor %}
{% endfor %}
