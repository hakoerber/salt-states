#!stateconf
{% from 'states/nginx/map.jinja' import nginx as nginx_map with context %}
{% from 'states/defaults.map.jinja' import defaults with context %}

.params:
    stateconf.set: []
# --- end of state config ---

{% if params.get('network_connect', false) == true %}
nginx-selinux-packages:
  pkg.installed:
    - pkgs:
      - policycoreutils
      - policycoreutils-python

nginx-selinux-bool-httpd-can-network-connect:
  selinux.boolean:
    - name: httpd_can_network_connect
    - value: 1
    - persist: True
    - require_in:
      - service: nginx
    - require:
      - pkg: nginx-selinux-packages
{% endif %}
