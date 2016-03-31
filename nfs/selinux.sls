#!stateconf

.params:
    stateconf.set: []
# --- end of state config ---

{% if params.get('homedirs_on_nfs', false) == true %}
nfs-selinux-nfs-homedirs:
  selinux.boolean:
    - name: use_nfs_home_dirs
    - value: 1
    - persist: True
{% endif %}
