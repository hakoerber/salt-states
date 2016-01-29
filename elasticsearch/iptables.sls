{% from 'states/elasticsearch/map.jinja' import elasticsearch as elasticsearch_map with context %}

{% set application = 'elasticsearch' %}
{% set ipv6 = False %}
{% set public = False %}
{% set components = elasticsearch_map.ports %}

{% include 'states/templates/iptables.sls.jinja' with context %}
