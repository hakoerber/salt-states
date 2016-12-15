#!stateconf

.params:
    stateconf.set: []
# --- end of state config ---

{% for mount in params.mounts %}
{% if mount.create %}
mountpoint-{{ mount.mountpoint }}:
  file.directory:
    - name: {{ mount.mountpoint }}
    - mode: {{ mount.mode }}
    - force: True
    - allow_symlink: False
    - user: {{ mount.user }}
    - group: {{ mount.group }}
    - require_in:
      - mount: mount-{{ mount.mountpoint }}
{% endif %}

mount-{{ mount.mountpoint }}:
  mount.mounted:
    - name: {{ mount.mountpoint }}
    - device: {{ mount.device }}
    - fstype: {{ mount.fstype }}
    - opts: {{ mount.opts }}
    - persist: True
    - mount: True
{% endfor %}
