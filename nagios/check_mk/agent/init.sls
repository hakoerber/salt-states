{% from 'states/nagios/map.jinja' import nagios as nagios_map with context %}
{% from 'states/defaults.map.jinja' import defaults with context %}

check_mk-agent:
{% if grains['os_family'] == 'FreeBSD' %}
  file.managed:
    - name: {{ nagios_map.check_mk.agent.script.path }}
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 755
    - source: {{ nagios_map.check_mk.agent.script.source }}
{% else %}
  pkg.installed:
    - name: {{ nagios_map.check_mk.agent.package }}
{% endif %}

  service.running:
    - name: {{ nagios_map.check_mk.agent.service }}
    - enable: true
{% if grains['os_family'] != 'FreeBSD' %}
    - require:
      - pkg: check_mk-agent
{% endif %}
