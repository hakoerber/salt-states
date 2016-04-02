#!stateconf
{% from 'states/syncrepo/map.jinja' import syncrepo as syncrepo_map with context %}

.params:
    stateconf.set: []
# --- end of state config ---

syncrepo-cron:
  cron.present:
    - name: perl -le 'sleep rand 60*60' ; syncrepo --config {{ syncrepo_map.conf_file }} >>/var/log/syncrepo.log 2>&1
    - user: root
    - minute: {{ params.minute }}
    - hour: {{ params.hour }}
    - comment: syncrepo
    - identifier: syncrepo
