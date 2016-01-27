{% from 'states/thruk/map.jinja' import thruk as thruk_map with context %}
{% from 'states/defaults.map.jinja' import defaults with context %}

selinux-dev:
  pkg.installed:
    - pkgs:
      - checkpolicy
      - policycoreutils
      - policycoreutils-python

thruk-selinux-module:
  c_selinux.module:
    - name: thruk_custom
    - source: salt://states/thruk/contrib/thruk_custom.te
    - require_in:
      - service: thruk
      - service: thruk-webserver
    - require:
      - pkg: thruk
      - pkg: selinux-dev

{% for boolean, value in thruk_map.selinux_booleans.items() %}
thruk-selinux-bool-{{ boolean }}:
  selinux.boolean:
    - name: {{ boolean }}
    - value: {{ value }}
    - persist: True
    - require_in:
      - service: thruk
      - service: thruk-webserver
    - require:
      - pkg: selinux-dev
{% endfor %}
