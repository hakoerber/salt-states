#!stateconf
{% from 'states/owncloud/map.jinja' import owncloud as owncloud_map with context %}
{% from 'states/defaults.map.jinja' import defaults with context %}

.params:
    stateconf.set: []
# --- end of state config ---

owncloud.conf:
  file.managed:
    - name: {{ owncloud_map.conf_file }}
    - user: {{ owncloud_map.user }}
    - group: {{ owncloud_map.group }}
    - mode: 640
    - source: salt://states/owncloud/files/config.php.jinja
    - template: jinja
    - defaults:
        params: {{ params }}
