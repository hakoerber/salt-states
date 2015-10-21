#!stateconf
{% from 'states/postfix/map.jinja' import postfix as postfix_map with context %}

postfix:
  pkg.installed:
    - name: {{ postfix_map.package }}

  service.running:
    - name: {{ postfix_map.service }}
    - enable: true
    - require:
      - pkg: postfix
