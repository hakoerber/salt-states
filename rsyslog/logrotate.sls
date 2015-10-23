{% from 'states/rsyslog/map.jinja' import rsyslog as rsyslog_map with context %}

{% set application = 'rsyslog' %}
{% set logging = rsyslog_map.client.logging %}
{% set files = [] %}
{% for log in rsyslog_map.client.logs %}
{% do files.append({'path': log.file}) %}
{% endfor %}
{% do logging.update({'files': files}) %}

{% include 'states/logrotate/templates/application.sls' with context %}
