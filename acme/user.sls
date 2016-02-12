{% from 'states/acme/map.jinja' import acme as acme_map with context %}
{% from 'states/defaults.map.jinja' import defaults with context %}

acme-user:
  user.present:
    - name: {{ acme_map.user }}
    - home: {{ acme_map.home }}
    - createhome: True
    - gid_from_name: True
    - shell: {{ defaults.nologin }}
    - groups:
      - nginx
    - require:
      - pkg: nginx
