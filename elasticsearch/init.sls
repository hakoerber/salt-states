{% from "states/elasticsearch/map.jinja" import elasticsearch as elasticsearch_map with context %}

elasticsearch:
  pkg.installed:
    - pkgs: {{ elasticsearch_map.packages }}

  service.running:
    - name: {{ elasticsearch_map.service }}
    - enable: true
    - require:
      - pkg: elasticsearch
