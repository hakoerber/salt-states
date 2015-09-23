{% from 'states/salt/map.jinja' import salt as salt_map with context %}

salt-master:
  service.running:
    - name: {{ salt_map.master.service }}
    - enable: true
