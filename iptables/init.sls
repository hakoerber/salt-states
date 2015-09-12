{% from "states/iptables/map.jinja" import iptables as iptables_map with context %}

iptables:
  pkg.installed:
    # this is better than requiring this package in every iptables state
    - order: 1
    - pkgs: {{ iptables_map.packages }}

{% for service in iptables_map.services %}
{{ service }}-service:
  service.running:
    - name: {{ service }}
    - enable: true
    - require:
      - pkg: iptables
{% endfor %}
