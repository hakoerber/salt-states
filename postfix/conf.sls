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
        relay: {{ params.get('relay', 'null') }}
        domain_authorative: {{ params.domain_authorative }}
        lmtp: {{ params.get('lmtp_relay', 'null') }}
        submit: {{ params.get('submit', 'null') }}
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
        ssl: {{ params.get('ssl', false) }}
        submit: {{ params.get('submit', 'null') }}
        listen_remote: {{ params.listen_remote }}
    - watch_in:
      - service: postfix
    - require:
      - pkg: postfix

postfix-login-map:
  file.managed:
    - name: {{ postfix_map.login_map }}
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 644
    - contents: '/^(.+)$/ $1'
    - watch_in:
      - service: postfix
    - onchanges_in:
      - cmd: postfix-login-map
    - require:
      - pkg: postfix

  cmd.run:
    - name: postmap {{ postfix_map.login_map }}
    - user: root
    - group: {{ defaults.rootgroup }}

postfix-virtual-mailboxes:
  file.managed:
    - name: {{ postfix_map.virtual_mailbox_file }}
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 644
    - source: salt://states/postfix/files/mapping.jinja
    - template: jinja
    - defaults:
        map:
{% for accept in params.accept %}
          - '{{ accept }}': _
{% endfor %}
    - onchanges_in:
      - cmd: postfix-virtual-mailboxes
    - require:
      - pkg: postfix

  cmd.run:
    - name: postmap {{ postfix_map.virtual_mailbox_file }}
    - user: root
    - group: {{ defaults.rootgroup }}

postfix-virtual-aliases:
  file.managed:
    - name: {{ postfix_map.virtual_aliases_file }}
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 644
    - source: salt://states/postfix/files/mapping.jinja
    - template: jinja
    - defaults:
        map: {{ postfix_map.aliases + params.get('aliases', []) }}
    - onchanges_in:
      - cmd: postfix-virtual-aliases
    - require:
      - pkg: postfix

  cmd.run:
    - name: postmap {{ postfix_map.virtual_aliases_file }}
    - user: root
    - group: {{ defaults.rootgroup }}
