{% from 'states/owncloud/map.jinja' import owncloud as owncloud_map with context %}
{% from 'states/defaults.map.jinja' import defaults with context %}

{% for boolean, value in owncloud_map.selinux.booleans.items() %}
owncloud-selinux-bool-{{ boolean }}:
  selinux.boolean:
    - name: {{ boolean }}
    - value: {{ value }}
    - persist: True
    - require_in:
      - service: owncloud
{% endfor %}
