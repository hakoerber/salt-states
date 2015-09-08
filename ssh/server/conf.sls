#!stateconf
{% from 'states/ssh/map.jinja' import ssh as ssh_map with context %}

.params:
    stateconf.set: []
# --- end of state config ---

sshd_config:
  file.managed:
    - name: {{ ssh_map.server.conf_file }}
    - user: root
    - group: {{ ssh_map.rootgroup }}
    - mode: 644
    - source: salt://states/ssh/files/sshd_config.jinja
    - template: jinja
    - context:
      ports: {{ ssh_map.server.ports }}
      sftp_binary: {{ ssh_map.server.sftp_binary }}
      keytypes: {{ ssh_map.server.keytypes }}
      listen_address: {{ params.listen_address }}
    {% if ssh_map.server.package != None %}
    - require:
      - pkg: ssh-server
    {% endif %}
    - watch_in:
      - service: ssh-server
