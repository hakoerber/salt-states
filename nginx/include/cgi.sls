{% from 'states/defaults.map.jinja' import defaults with context %}

selinux-dev:
  pkg.installed:
    - pkgs:
      - checkpolicy
      - policycoreutils
      - policycoreutils-python

{% set policy = 'nginx_cgi' %}

cgi-selinux-package:
  cmd.run:
    - cwd: /root
    - name: >
        checkmodule -M -m -o {{ policy }}.mod {{ policy }}.te &&
        semodule_package -o {{ policy }}.pp -m {{ policy }}.mod &&
        semodule -i {{ policy }}.pp
    - unless: semodule -l | grep -q ^{{ policy }}
    - watch:
      - file: cgi-selinux-policyfile
    - require:
      - pkg: selinux-dev

cgi-selinux-policyfile:
  file.managed:
    - name: /root/{{ policy }}.te
    - user: root
    - group: {{ defaults.rootgroup }}
    - source: salt://states/nginx/contrib/{{ policy }}.te

