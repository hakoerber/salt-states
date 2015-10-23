{% from 'states/bind/map.jinja' import bind as bind_map with context %}

{% set application = 'bind' %}
{% set logging = bind_map.logging %}
{% include 'states/logrotate/templates/application.sls' with context %}
