#!stateconf

.params:
    stateconf.set: []
# --- end of state config ---

hostname:
  c_hostname.set:
    - name: {{ params.hostname }}
