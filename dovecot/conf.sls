#!stateconf
{% from 'states/dovecot/map.jinja' import dovecot as dovecot_map with context %}
{% from 'states/defaults.map.jinja' import defaults with context %}

.params:
    stateconf.set: []
# --- end of state config ---

dovecot.conf:
  file.managed:
    - name: {{ dovecot_map.conf.main_file }}
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 640
    - source: salt://states/dovecot/files/dovecot.conf.jinja
    - template: jinja
    - watch_in:
      - service: dovecot

{% for include in dovecot_map.conf.include %}
dovecot-{{ include }}.conf:
  file.managed:
    - name: {{ dovecot_map.conf.includedir }}/{{ include }}.conf
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 640
    - source: salt://states/dovecot/files/include/{{ include }}.conf.jinja
    - template: jinja
    - defaults:
        lmtp_socket: {{ params.lmtp_socket }}
        auth_socket: {{ params.auth_socket }}
    - require:
      - pkg: dovecot
    - watch_in:
      - service: dovecot
{% endfor %}

dovecot-conf.d:
  file.directory:
    - name: {{ dovecot_map.conf.includedir }}
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 755
    - clean: True
    - require:
      - pkg: dovecot
      - file: dovecot.conf
{% for include in dovecot_map.conf.include %}
      - file: dovecot-{{ include }}.conf
{% endfor %}
    - watch_in:
      - service: dovecot

dovecot-vmail-user:
  user.present:
    - name: {{ dovecot_map.virtual_user }}
    - home: {{ dovecot_map.virtual_home }}
    - createhome: True
    - gid_from_name: True
    - system: True
    - require:
      - pkg: dovecot

dovecot-passwd:
  file.managed:
    - name: {{ dovecot_map.conf.passwd_file }}
    - user: {{ dovecot_map.user }}
    - group: {{ dovecot_map.user }}
    - mode: 600
    - source: salt://states/dovecot/files/passwd.jinja
    - defaults:
        users: {{ params.users }}
    - template: jinja
    - watch_in:
      - service: dovecot
