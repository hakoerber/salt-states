#!stateconf
{% from 'states/nagios/map.jinja' import nagios as nagios_map with context %}
{% from 'states/defaults.map.jinja' import defaults with context %}

.params:
    stateconf.set: []
# --- end of state config ---

{% set allow_from = params.get('allow_from', false) %}

livestatus-xinetd.conf:
  file.managed:
    - name: /etc/xinetd.d/livestatus
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 644
    - source: salt://states/nagios/files/livestatus.xinetd.jinja
    - defaults:
        allow_from: {{ allow_from }}
    - template: jinja
    - require:
      - pkg: xinetd
      - pkg: check_mk-server-livestatus
    - watch_in:
      - service: xinetd

{% if allow_from != false %}
{% set application = 'livestatus' %}
{% set ipv6 = False %}
{% set public = False %}
{% set ports = {'tcp': nagios_map.check_mk.server.livestatus.port} %}
{% set source = allow_from|map(attribute='ip')|join(',') %}

{% include 'states/templates/iptables.sls.jinja' with context %}
{% endif %}
