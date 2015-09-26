{% from 'states/logstash/map.jinja' import logstash as logstash_map with context %}

logstash:
  pkg.installed:
    - name: {{ logstash_map.package }}

  service.running:
    - name: {{ logstash_map.service }}
    - enable: true
    - require:
      - pkg: logstash
