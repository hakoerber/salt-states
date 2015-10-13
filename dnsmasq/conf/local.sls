#!stateconf
{% from 'states/dnsmasq/map.jinja' import dnsmasq as dnsmasq_map with context %}
{% from 'states/defaults.map.jinja' import defaults with context %}

.params:
    stateconf.set: []
# --- end of state config ---

dnsmasq.conf:
  file.managed:
    - name: {{ dnsmasq_map.conf_file }}
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 644
    - source: salt://states/dnsmasq/files/dnsmasq.conf.local.jinja
    - template: jinja
    - defaults:
        domain: {{ params.domain }}
        reverse_domain: {{ params.reverse_domain }}
        nameservers: {{ params.nameservers }}
    - watch_in:
      - service: dnsmasq
    - require:
      - pkg: dnsmasq
