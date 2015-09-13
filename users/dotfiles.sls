#!stateconf
{% from 'states/defaults.map.jinja' import defaults with context %}
{% from 'states/users/map.jinja' import packages as package_map with context %}

.params:
    stateconf.set: []
# --- end of state config ---

{% for user in params.users %}
{% for application in user.dotfiles %}

{% if application.packages is defined %}
{% set pkgs = [] %}
{% for pkg in application.packages %}
{% do pkgs.append(package_map[pkg]) %}
{% endfor %}
dotfiles-packages-{{ application.name }}:
  pkg.installed:
    - pkgs: {{ pkgs }}
{% endif %}

{% for file in application.files %}
{% set template = file.get('template', False) %}
dotfiles-{{ application.name }}-{{ file.name }}:
  file.managed:
    - name: {{ user.home }}/.{{ file.name }}
    - user: {{ user.name }}
    - group: {{ user.name }}
    - makedirs: True
    - mode: 600
    - source: salt://files/users/{{ user.name }}/dotfiles/{{ file.name }}
    {% if template %}
    - template: jinja
    - defaults:
        user: {{ user }}
    {% endif %}
    {% if application.packages is defined %}
    - require:
      - pkg: dotfiles-packages-{{ application.name }}
    {% endif %}
{% endfor %}
{% endfor %}
{% endfor %}
