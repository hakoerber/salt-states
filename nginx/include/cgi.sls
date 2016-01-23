selinux-dev:
  pkg.installed:
    - pkgs:
      - checkpolicy
      - policycoreutils
      - policycoreutils-python

nginx-selinux-cgi:
  c_selinux.module:
    - name: nginx_cgi
    - source: salt://states/nagios/contrib/nginx_cgi.te
    - require_in:
      - service: nginx
    - require:
      - pkg: nginx
      - pkg: selinux-dev
