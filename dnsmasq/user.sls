{% from 'states/dnsmasq/map.jinja' import dnsmasq as dnsmasq_map with context %}
{% from 'states/defaults.map.jinja' import defaults with context %}

dnsmasq-user:
  user.present:
    - name: {{ dnsmasq_map.user }}
    - home: {{ dnsmasq_map.homedir }}
    - system: True
    - shell: {{ defaults.nologin }}
    - gid_from_name: True
    - require_in:
      - service: dnsmasq
