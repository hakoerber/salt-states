#!stateconf
{% from 'states/dovecot/map.jinja' import dovecot as dovecot_map with context %}

{% set application = 'dovecot' %}
{% set ipv6 = False %}
{% set public = False %}
{% set components = dovecot_map.ports %}

{% include 'states/templates/iptables.sls.jinja' with context %}
