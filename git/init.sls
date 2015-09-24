{% from 'states/git/map.jinja' import git as git_map with context %}

git:
  pkg.installed:
    - name: {{ git_map.package }}
