#!stateconf

.params:
    stateconf.set: []
# --- end of state config ---

{# currently no support for ipv6 zones #}
{% set families = ['ipv4', 'ipv6'] %}

{% for zone in params.zones %}
{% set zonechain = "ZONE_" ~ zone.name|upper %}

{% for family in families %}

{% if family == 'ipv6' %}
{% if zonechain != 'ZONE_PUBLIC' %}
{% continue %}
{% endif %}
{% endif %}

chain_zone_{{ zone.name }}_{{ family }}:
  iptables.chain_present:
    - name: {{ zonechain }}
    - family: {{ family }}

{% set sourceid = 0 %}
{% for source in zone.sources %}
{% set sourceid = sourceid + 1 %}

jump_to_zone_{{ zone.name }}_{{ family }}_source_{{ sourceid }}:
  iptables.append:
    - table: filter
    - chain: TCPUDP
    - jump: {{ zonechain }}
    - family: {{ family }}
    - source: {{ source }}
    - save: true
    - require:
      - iptables: chain_zone_{{ zone.name }}_{{ family }}
      - iptables: chain_tcpudp_{{ family }}

{% endfor %}
{% endfor %}
{% endfor %}
