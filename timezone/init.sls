#!stateconf

.params:
    stateconf.set: []
# --- end of state config ---

timezone:
  timezone.system:
    - name: {{ params.timezone }}
    - utc: true
