{% from 'states/git/map.jinja' import git as git_map with context %}

git-user:
  user.present:
    - name: {{ git_map.user }}
    - home: {{ git_map.home }}
    - createhome: True
    - gid_from_name: True
    - require:
      - pkg: git
