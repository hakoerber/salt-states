#!stateconf
{% from 'states/defaults.map.jinja' import defaults with context %}

.params:
    stateconf.set: []
# --- end of state config ---

{% for username, user in params.users.items() %}
{% for authorized_key in user.get('ssh', {}).get('authorized_keys', []) %}
authorized-keys-{{ authorized_key.comment }}:
  ssh_auth.present:
    - name: {{ authorized_key.key }}
    - user: {{ username }}
    - enc: {{ authorized_key.type }}
    - comment: {{ authorized_key.comment }}
{% endfor %}

{% for authorized_user in user.get('ssh', {}).get('authorized_users', []) %}
authorized-keys-{{ authorized_user }}:
  ssh_auth.present:
    - name: {{ salt['pillar.get']('userkeys:' + authorized_user + ':id_rsa.pub') }}
    - user: {{ username }}
{% endfor %}
{% endfor %}
