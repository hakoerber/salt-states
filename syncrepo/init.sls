#!stateconf
{% from 'states/syncrepo/map.jinja' import syncrepo as syncrepo_map with context %}

syncrepo:
  pkg.installed:
    - pkgs: {{ syncrepo_map.packages }}
