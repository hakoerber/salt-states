#!stateconf
{% from 'states/owncloud/map.jinja' import owncloud as owncloud_map with context %}

owncloud:
  pkg.installed:
    - pkgs: {{ owncloud_map.packages }}

  service.running:
    - name: {{ owncloud_map.service }}
    - enable: true
    - require:
      - pkg: owncloud
