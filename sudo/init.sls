{% from 'states/sudo/map.jinja' import sudo as sudo_map with context %}

sudo:
  pkg.installed:
    - name: {{ sudo_map.package }}
