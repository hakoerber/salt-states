{% from 'states/sudo/map.jinja' import sudo as sudo_map with context %}

{% set application = 'sudo' %}
{% set logging = sudo_map.logging %}
{% include 'states/logrotate/templates/application.sls' with context %}
