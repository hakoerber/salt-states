#!stateconf
{% from 'states/influxdb/map.jinja' import influxdb as influxdb_map with context %}

{% set application = 'influxdb' %}
{% set ipv6 = False %}
{% set public = False %}
{% set ports = influxdb_map.ports %}

{% include 'states/templates/iptables.sls.jinja' with context %}
