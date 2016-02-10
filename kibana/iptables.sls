{% from 'states/kibana/map.jinja' import kibana as kibana_map with context %}

{% set application = 'kibana' %}
{% set ipv6 = False %}
{% set public = False %}
{% set components = kibana_map.ports %}

{% include 'states/templates/iptables.sls.jinja' with context %}
