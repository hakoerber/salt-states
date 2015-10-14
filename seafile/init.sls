{% from "states/seafile/map.jinja" import seafile as seafile_map with context %}

{% for service in seafile_map.services %}
seafile-service-{{ service }}:
  service.running:
    - name: {{ service }}
    - enable: true
{% endfor %}
