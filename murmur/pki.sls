#!stateconf
{% from 'states/murmur/map.jinja' import murmur as murmur_map with context %}
{% from 'states/defaults.map.jinja' import defaults with context %}

.params:
    stateconf.set: []
# --- end of state config ---

murmur-pkidir:
  file.directory:
    - name: {{ murmur_map.pki.dir }}
    - user: {{ murmur_map.user }}
    - group: {{ murmur_map.group }}
    - mode: 700

murmur-ssl-cert:
  file.managed:
    - name: {{ murmur_map.pki.dir }}/{{ murmur_map.pki.cert }}
    - user: {{ murmur_map.user }}
    - group: {{ murmur_map.group }}
    - mode: 600
    - contents_pillar: murmur:pki:fullchain.pem
    - show_changes: false
    - require:
      - file: murmur-pkidir
    - watch_in:
      - service: murmur

murmur-ssl-key:
  file.managed:
    - name: {{ murmur_map.pki.dir }}/{{ murmur_map.pki.key }}
    - user: {{ murmur_map.user }}
    - group: {{ murmur_map.group }}
    - mode: 600
    - contents_pillar: murmur:pki:privkey.pem
    - show_changes: false
    - require:
      - file: murmur-pkidir
    - watch_in:
      - service: murmur
