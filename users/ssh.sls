#!stateconf
{% from 'states/defaults.map.jinja' import defaults with context %}

.params:
    stateconf.set: []
# --- end of state config ---

{% for user in params.users %}
{% for authorized_key in user.get('ssh', {}).get('authorized_keys', []) %}
authorized-keys-{{ authorized_key.comment }}:
  ssh_auth.present:
    - name: {{ authorized_key.key }}
    - user: {{ user.name }}
    - enc: {{ authorized_key.type }}
    - comment: {{ authorized_key.comment }}
{% endfor %}

{% for authorized_user in user.get('ssh', {}).get('authorized_users', []) %}
authorized-keys-{{ authorized_user.name }}
  ssh_auth.present:
    - user: {{ user.name }}
    - source: salt://users/{{ authorized_user.name }}/ssh/id_rsa.pub
{% endfor %}
{% endfor %}
