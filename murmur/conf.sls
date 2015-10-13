#!stateconf
{% from 'states/murmur/map.jinja' import murmur as murmur_map with context %}
{% from 'states/defaults.map.jinja' import defaults with context %}

.params:
    stateconf.set: []
# --- end of state config ---

murmur.ini:
  file.managed:
    - name: {{ murmur_map.conf_file }}
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 644
    - source: salt://states/murmur/files/murmur.ini.jinja
    - template: jinja
    - defaults:
        password: {{ params.password }}
    - watch_in:
      - service: murmur

murmur-user:
  user.present:
    - name: {{ murmur_map.user }}
    - system: True
    - home: {{ murmur_map.home }}
    - gid_from_name: True
    - shell: {{ defaults.nologin }}

