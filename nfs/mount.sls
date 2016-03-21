#!stateconf
{% from 'states/nfs/map.jinja' import nfs as nfs_map with context %}
{% from 'states/defaults.map.jinja' import defaults with context %}

.params:
    stateconf.set: []
# --- end of state config ---

{% for mount in params.mounts %}
{% set name = mount.path|replace('/', '-') %}
nfs-mount-{{ name }}:
  mount.mounted:
    - name: {{ mount.path }}
    - device: {{ mount.server.name }}:{{ mount.server.path }}
    - fstype: nfs
    - persist: true
    - opts:
      - defaults
      # vers is synonym to nfsvers, but because the mount command shows nfsvers
      # as vers, salt thinks that mount versions changed every time the salt is
      # executed when nfsvers is used
      - vers={{ mount.get('version', '3') }}
    - mkmnt: False
    - require:
      - file: nfs-mount-{{ name }}-mountpoint

nfs-mount-{{ name }}-mountpoint:
  file.directory:
    - name: {{ mount.path }}
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 700
    - makedirs: true
{% endfor %}
