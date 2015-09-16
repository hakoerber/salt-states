#!stateconf
{% from 'states/package/map.jinja' import package as package_map with context %}
{% from 'states/defaults.map.jinja' import defaults with context %}

.params:
    stateconf.set: []
# --- end of state config ---

{% if grains['os_family'] == 'RedHat' %}
yum-cron.conf:
  file.managed:
    - name: {{ package_map.autoupdate.conf_path }}
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 644
    - source: {{ package_map.autoupdate.conf_source }}
    - template: jinja
    - defaults:
        mode: {{ params.get('mode', package_map.autoupdate.default_mode) }}
    - require:
      - pkg: yum-cron
    - watch_in:
      - service: yum-cron

{% elif grains['os_family'] == 'Debian' %}
50unattended-upgrades:
  file.managed:
    - name: {{ package_map.autoupdate.conf.conf_50unattended_upgrades.path }}
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 644
    - source: {{ package_map.autoupdate.conf.conf_50unattended_upgrades.source }}
    - require:
      - pkg: unattended-upgrades

20auto-upgrades:
  file.managed:
    - name: {{ package_map.autoupdate.conf.conf_20auto_upgrades.path }}
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 644
    - source: {{ package_map.autoupdate.conf.conf_20auto_upgrades.source }}
    - require:
      - pkg: unattended-upgrades
{% endif %}
