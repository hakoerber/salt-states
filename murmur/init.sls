#!stateconf
{% from 'states/murmur/map.jinja' import murmur as murmur_map with context %}

murmur:
  service.running:
    - name: {{ murmur_map.service }}
    - enable: true
