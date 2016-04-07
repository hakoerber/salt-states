#!stateconf
{% from 'states/quassel/map.jinja' import quassel as quassel_map with context %}

{% set application = 'quassel' %}
{% set ipv6 = False %}
{% set public = False %}
{% set ports = quassel_map.core.ports %}

{% include 'states/templates/iptables.sls.jinja' with context %}
