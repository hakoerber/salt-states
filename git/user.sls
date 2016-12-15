#!stateconf
{% from 'states/git/map.jinja' import git as git_map with context %}

.params:
    stateconf.set: []
# --- end of state config ---

git-group:
  group.present:
    - name: {{ git_map.user }}
    - gid: {{ git_map.gid }}
    - system: True

git-user:
  user.present:
    - name: {{ git_map.user }}
    - home: {{ git_map.home }}
    - uid: {{ git_map.uid }}
    - gid: {{ git_map.gid }}
    - createhome: True
    - system: True
    - require:
      - pkg: git
      - group: git-group

{% for user in params.allowed_users %}
git-{{ user.name }}:
  ssh_auth.present:
    - name: {{ user.key }}
    - user: {{ git_map.user }}
    - enc: {{ user.keytype }}
    - comment: {{ user.name }}
    - require:
      - user: git-user
{% endfor %}
