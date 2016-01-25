{% from "states/iptables/map.jinja" import iptables as iptables_map with context %}
{% from 'states/defaults.map.jinja' import defaults with context %}

iptables:
  pkg.installed:
    # this is better than requiring this package in every iptables state
    - order: 10
    - pkgs: {{ iptables_map.packages }}

{% for service, serviceconf in iptables_map.services.items() %}
{{ service }}-service:
  service.running:
    - name: {{ service }}
    - enable: true
    - require:
      - pkg: iptables

{{ service }}-config-exists:
  file.managed:
    - name: {{ serviceconf.conf }}
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 600
    - require_in:
      - service: {{ service }}-service
{% endfor %}
