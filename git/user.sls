{% from 'states/git/map.jinja' import git as git_map with context %}

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
