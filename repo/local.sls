#!stateconf
.params:
    stateconf.set: []
# --- end of state config ---

{% for repo, mirrors in params.localrepos.items() %}
{% set nogpg = [] %}
repository-{{ repo }}:
  pkgrepo.managed:
    - name: {{ repo }}
    - humanname: {{ repo }}
    - baseurl: |
{% for mirror in mirrors %}
        http://{{ mirror.name }}.{{ mirror.domain }}/{{ mirror.url }}
{% endfor %}

{% for mirror in mirrors %}
{% if mirror.get('gpg', true) == false %}
{% do nogpg.append(1) %}
{% endif %}
{% endfor %}
{% if nogpg %}
    - gpgcheck: 0
{% else %}
    - gpgcheck: 1
{% endif %}

{% endfor %}
