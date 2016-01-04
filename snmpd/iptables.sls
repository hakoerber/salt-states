#!stateconf
{% from 'states/snmpd/map.jinja' import snmpd as snmpd_map with context %}

{% set application = 'snmpd' %}
{% set ipv6 = False %}
{% set public = False %}
{% set ports = snmpd_map.ports %}

{% include 'states/templates/iptables.sls.jinja' with context %}
