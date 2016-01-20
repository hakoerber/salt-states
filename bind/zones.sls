#!stateconf
{% from 'states/bind/map.jinja' import bind as bind_map with context %}
{% from 'states/defaults.map.jinja' import defaults with context %}

.params:
    stateconf.set: []
# --- end of state config ---

reload_zones:
  cmd.wait:
    - name: rndc reload

{% if params.role == 'master' %}
{% set grain = 'bind_zone_serial_' ~ params.domain %}
{% set newserial_date = salt['cmd.run']('date +%Y%m%d') %}
{% set oldserial = grains.get(grain, none) %}
{% if oldserial is none %}
{% set newserial = newserial_date ~ '01' %}
{% set oldserial = newserial %}
{% else %}
{% set oldserial_date = oldserial|string|truncate(8, true, '') %}
{% set oldserial_rev = oldserial|string|replace(oldserial_date, '') %}
{% if oldserial_date == newserial_date %}
{% set newserial_rev = oldserial_rev|int + 1 %}
{% set newserial_rev = '%02d'|format(newserial_rev) %}
{% set newserial = oldserial_date ~ newserial_rev %}
{% else %}
{% set newserial = newserial_date ~ '01' %}
{% endif %}
{% endif %}

zone-{{ params.domain }}-store-serial-grain:
  grains.present:
    - name: bind_zone_serial_{{ params.domain }}
    - value: {{ newserial }}
    - force: true

{% for direction in ['forward', 'reverse'] %}
zone-{{ params.domain }}-{{ direction }}-check:
  file.managed:
    - name: {{ bind_map.main_directory }}/{{ direction }}.{{ params.domain }}
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 644
    - source: 'salt://states/bind/files/{{ direction }}.zone.jinja'
    - template: jinja
    - defaults:
        params: {{ params }}
        serial: {{ oldserial }}
    - require:
      - pkg: bind
    - onchanges_in:
      - grains: zone-{{ params.domain }}-store-serial-grain

zone-{{ params.domain }}-{{ direction }}:
  file.managed:
    - name: {{ bind_map.main_directory }}/{{ direction }}.{{ params.domain }}
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 644
    - source: 'salt://states/bind/files/{{ direction }}.zone.jinja'
    - template: jinja
    - defaults:
        params: {{ params }}
        serial: {{ newserial }}
    - require_in:
      - file: named.conf
    - watch_in:
      - cmd: reload_zones
    - require:
      - pkg: bind
    - onchanges:
      - file: zone-{{ params.domain }}-{{ direction }}-check
{% endfor %}
{% endif %}
