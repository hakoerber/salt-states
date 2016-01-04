#!stateconf
{% from 'states/ssh/map.jinja' import ssh as ssh_map with context %}

{% set application = 'ssh-server' %}
{% set ipv6 = True %}
{% set public = True %}
{% set ports = ssh_map.server.ports %}

{% include 'states/templates/iptables.sls.jinja' with context %}
