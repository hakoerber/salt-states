{% from 'states/nagios/map.jinja' import nagios as nagios_map with context %}
{% from 'states/defaults.map.jinja' import defaults with context %}

selinux-dev:
  pkg.installed:
    - pkgs:
      - checkpolicy
      - policycoreutils
      - policycoreutils-python

nagios-selinux-module-sock:
  c_selinux.module:
    - name: nagios_custom
    - source: salt://states/nagios/contrib/nagios_custom.te
    - require_in:
      - service: nagios
    - require:
      - pkg: nagios
      - pkg: selinux-dev

nagios-selinux-bool-enable-cluster-mode:
  selinux.boolean:
    - name: daemons_enable_cluster_mode
    - value: 1
    - persist: True
    - require_in:
      - service: nagios
    - require:
      - pkg: selinux-dev

nagios-var-run-context:
  cmd.run:
    - name: restorecon -vR {{ nagios_map.socket_dir }}
    - user: root
    - group: {{ defaults.rootgroup }}
    - require:
      - pkg: nagios
      - pkg: selinux-dev
      - file: nagios-socketdir
    - onchanges:
      - file: nagios-socketdir
    - watch_in:
      - service: nagios
