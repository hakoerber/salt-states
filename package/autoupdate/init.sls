{% from 'states/package/map.jinja' import package as package_map with context %}

{% if grains['os_family'] == 'RedHat' %}
yum-cron:
  pkg.installed:
    - name: {{ package_map.autoupdate.package }}

  service.running:
    - name: {{ package_map.autoupdate.service }}
    - enable: True
    - require:
      - pkg: yum-cron

{% elif grains['os_family'] == 'Debian' %}
unattended-upgrades:
  pkg.installed:
    - name: {{ package_map.autoupdate.package }}
{% endif %}
