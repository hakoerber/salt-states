#!stateconf
{% from 'states/postfix/map.jinja' import postfix as postfix_map with context %}
{% from 'states/defaults.map.jinja' import defaults with context %}

.params:
    stateconf.set: []
# --- end of state config ---

postfix-pkidir:
  file.directory:
    - name: {{ postfix_map.pkidir }}
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 700
    - require:
      - pkg: postfix

postfix-ssl-cert:
  file.managed:
    - name: {{ postfix_map.pkidir }}/{{ postfix_map.cert }}
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 600
    - source: salt://files/postfix/ssl/{{ grains['id'] }}/fullchain.pem
    - show_diff: false
    - require:
      - file: postfix-pkidir
    - watch_in:
      - service: postfix

postfix-ssl-key:
  file.managed:
    - name: {{ postfix_map.pkidir }}/{{ postfix_map.key }}
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 600
    - source: salt://files/postfix/ssl/{{ grains['id'] }}/privkey.pem
    - show_diff: false
    - require:
      - file: postfix-pkidir
    - watch_in:
      - service: postfix

{% set master_files = salt['cp.list_master']() %}
{% set dhparams_path = 'files/postfix/ssl/' ~ grains['id'] ~ '/dhparams.pem' %}
{% set master_has_dhparams = dhparams_path in master_files %}
{% set dhparams = postfix_map.pkidir ~ '/' ~ postfix_map.dhparams %}
postfix-ssl-dhparams:
  file.managed:
    - name: {{ dhparams }}
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 600
    - require:
      - file: postfix-pkidir
    - watch_in:
      - service: postfix
{% if master_has_dhparams or params.get('master_dhparams', false) == true %}
    - source: salt://{{ dhparams_path }}
    - show_diff: false
{% else %}
    - require:
      - cmd: postfix-ssl-dhparams-create

postfix-ssl-dhparams-create:
  cmd.run:
    - name: openssl dhparam -out {{ dhparams }} {{ postfix_map.dh_bits }}
    - user: root
    - group: {{ defaults.rootgroup }}
    - creates: {{ dhparams }}
    - require:
      - file: postfix-pkidir
    - watch_in:
      - service: postfix
{% endif %}
