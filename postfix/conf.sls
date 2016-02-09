#!stateconf
{% from 'states/postfix/map.jinja' import postfix as postfix_map with context %}
{% from 'states/defaults.map.jinja' import defaults with context %}

.params:
    stateconf.set: []
# --- end of state config ---

postfix-main.cf:
  file.managed:
    - name: {{ postfix_map.main_cf }}
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 644
{% if params.listen_remote %}
    - source: salt://states/postfix/files/main.cf.server.jinja
    - defaults:
        ssl: {{ params.get('ssl', false) }}
        hostname: {{ params.hostname }}
        domain: {{ params.domain }}
        relay: {{ params.get('relay') }}
        domain_authorative: {{ params.domain_authorative }}
{% else %}
    - source: salt://states/postfix/files/main.cf.local.jinja
{% endif %}
    - template: jinja
    - watch_in:
      - service: postfix
    - require:
      - pkg: postfix

postfix-master.cf:
  file.managed:
    - name: {{ postfix_map.master_cf }}
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 644
    - source: salt://states/postfix/files/master.cf.jinja
    - template: jinja
    - defaults:
        listen_remote: {{ params.listen_remote }}
    - watch_in:
      - service: postfix
    - require:
      - pkg: postfix

postfix-aliases:
  file.managed:
    - name: {{ postfix_map.aliasesfile }}
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 644
    - source: salt://states/postfix/files/aliases.jinja
    - template: jinja
    - defaults:
        aliases: {{ postfix_map.aliases + params.get('aliases', []) }}
    - watch_in:
      - cmd: postfix-aliases
    - require:
      - pkg: postfix

  cmd.wait:
    - name: newaliases
