#!stateconf
{% from 'states/defaults.map.jinja' import defaults with context %}
{% from 'states/users/map.jinja' import shells as shell_map with context %}

.params:
    stateconf.set: []
# --- end of state config ---

{% for username, user in params.users.items() %}

{% set groups = user.get('groups', []) %}
{% for group in groups %}
group-{{ group }}:
  group.present:
    - name: {{ group }}
{% endfor %}

user-{{ username }}:
  {% if username == 'root' %}
  {% set groupname = defauts.rootgroup %}
  {% else %}
  {% set groupname = username %}
  {% endif %}
  group.present:
    - name: {{ groupname }}

  user.present:
    - name: {{ username }}

    {% if user.uid is defined %}
    - uid: {{ user.uid }}
    {% endif %}

    - gid: {{ groupname }}

    {% if user.shell is defined %}
    - shell: {{ shell_map[user.shell] }}
    {% endif %}

    {% if user.home is defined %}
    - home: {{ user.home }}
    {% endif %}

    - createhome: True

    - password: {{ user.password }}

    {% if user.groups is defined %}
    - groups: {{ user.groups }}
    {% endif %}

    - require:
      - group: user-{{ username }}
      {% for group in groups %}
      - group: group-{{ group }}
      {% endfor %}
{% endfor %}
