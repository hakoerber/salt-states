#!stateconf
{% from 'states/radicale/map.jinja' import radicale as radicale_map with context %}

{% set application = 'radicale' %}
{% set ipv6 = False %}
{% set public = False %}
{% set ports = radicale_map.ports %}

{% include 'states/templates/iptables.sls.jinja' with context %}
