{% from 'states/jenkins/map.jinja' import jenkins as jenkins_map with context %}

{% set application = 'jenkins' %}
{% set ipv6 = False %}
{% set public = False %}
{% set ports = jenkins_map.ports %}

{% include 'states/templates/iptables.sls.jinja' with context %}
