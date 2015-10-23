{% from 'states/nginx/map.jinja' import nginx as nginx_map with context %}

{% set application = 'nginx' %}
{% set logging = nginx_map.logging %}
{% include 'states/logrotate/templates/application.sls' with context %}
