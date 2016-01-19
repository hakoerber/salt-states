{% from 'states/nagios/map.jinja' import nagios as nagios_map with context %}
{% from 'states/defaults.map.jinja' import defaults with context %}

{% set policy = {
  'name': 'nagios_sock',
  'file': 'salt://states/nagios/contrib/nagios_sock.te',
  'require_in': [{'service': 'nagios'}],
} %}

{% include 'states/templates/selinux.sls.jinja' with context %}

nagios-selinux-module-sock:
  _selinux.module:
    - name: nagios_sock
    - source: salt://nagios/contrib/nagios_sock.te
    - require_in:
      - service: nagios

nagios-selinux-bool-enable-cluster-mode:
  selinux.boolean:
    - name: daemons_enable_cluster_mode
    - value: 1
    - persist: True
    - require_in:
      - service: nagios
    - require:
      - pkg: selinux-dev-nagios_sock

nagios-var-run-context:
  cmd.run:
    - name: restorecon -vR {{ nagios_map.sockdir }}
    - user: root
    - group: {{ defaults.rootgroup }}
    - require:
      - pkg: nagios
      - pkg: selinux-dev-nagios_sock
      - file: nagios-socketdir
    - watch_in:
      - service: nagios
