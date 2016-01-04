#!stateconf
{% from 'states/postgresql/map.jinja' import postgresql as postgresql_map with context %}

{% set application = 'postgresql-server' %}
{% set ipv6 = False %}
{% set public = False %}
{% set ports = postgresql_map.ports %}

{% include 'states/templates/iptables.sls.jinja' with context %}
