#!stateconf
{% from 'states/elasticsearch/map.jinja' import elasticsearch as elasticsearch_map with context %}

.params:
    stateconf.set: []
# --- end of state config ---

{% set application = 'elasticsearch' %}
{% set ipv6 = False %}
{% set public = False %}

{% if params.get('local', false) %}
{% set components = {'transport': elasticsearch_map.ports.transport} %}
{% else %}
{% set components = elasticsearch_map.ports %}
{% endif %}

{% include 'states/templates/iptables.sls.jinja' with context %}
