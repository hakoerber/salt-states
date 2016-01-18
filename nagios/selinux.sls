{% set policy = {
  'name': 'nagios_sock',
  'file': 'salt://states/nagios/contrib/nagios_sock.te'
} %}

{% include 'states/templates/selinux.sls.jinja' with context %}
