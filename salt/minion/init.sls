{% from 'states/salt/map.jinja' import salt as salt_map with context %}

salt-minion:
  service.running:
    - name: {{ salt_map.minion.service }}
    - enable: true

salt-restart-minion:
  # see https://docs.saltstack.com/en/latest/faq.html#what-is-the-best-way-to-restart-a-salt-daemon-using-salt
  # adapted slightly
  cmd.wait:
    - name: |
        /bin/sh -c 'sleep 10 && salt-call --local service.restart {{ salt_map.minion.service }}' 1>&- 2>&- &
    - order: last
