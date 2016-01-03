#!stateconf
.params:
    stateconf.set: []
# --- end of state config ---

{% for repo, mirrors in params.localrepos.items() %}
repository-{{ repo }}:
  pkgrepo.managed:
    - name: {{ repo }}
    - humanname: {{ repo }}
    - baseurl: |
        {% for mirror in mirrors %}
        http://{{ mirror.name }}.{{ mirror.domain }}/{{ mirror.url }}
        {% endfor %}

{% endfor %}#}
