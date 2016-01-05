#!stateconf
{% from 'states/openvpn/map.jinja' import openvpn as openvpn_map with context %}
{% from 'states/defaults.map.jinja' import defaults with context %}

.params:
    stateconf.set: []
# --- end of state config ---

{#
When advertising a subnet from a client, the
server will push a route to that subnet to all clients, so they route the
traffic meant to the subnet to the server which forwards it to the respective
client.

The problem is that this route will be pushed to ALL servers, even the one that
acts as the gateway to the subnet. This creates a routing loop between that
client and the server for the subnet.

For this reason we need to filter the routes on clients advertising subnets,
and reject the problematic route. This is done with a combination of two
parameters: route-noexec and route-up. This delegates adding of routes to the
script given to route-up, which we also give the IP and netmask of the
advertised subnet.

The script then has to add all routes in the usual way ("ip" or "route"), but
ignore the route matching the parameters.

See contrib/route-filter for the script.
#}

{% set create_scriptdir = [] %}
{% for vpnname, vpn in params.vpns.items() %}
{% set advertise_subnet = vpn.get('clients', {}).get(grains['id'], {}).get('options', {}).get('advertise_subnet', {}) %}

openvpn-client-{{ vpnname }}.conf:
  file.managed:
    - name: {{ openvpn_map.confdir }}/client-{{ vpnname }}.conf
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 644
    - source: salt://states/openvpn/files/client.conf.jinja
    - template: jinja
    - defaults:
        vpnname: {{ vpnname }}
        vpn: {{ vpn }}
        advertise_subnet: {{ advertise_subnet }}
    - watch_in:
      - service: openvpn-client-{{ vpnname }}-service
    - require:
      - pkg: openvpn
      {% if advertise_subnet != {} %}
      {% do create_scriptdir.append(1) %}
      - file: openvpn-client-script-route-filter
      {% endif %}

{% endfor %}

{% if create_scriptdir %}
openvpn-client-scriptdir:
  file.directory:
    - name: {{ openvpn_map.confdir }}/{{ openvpn_map.scriptdir }}
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 700
    - require:
      - pkg: openvpn

openvpn-client-script-route-filter:
  file.managed:
    - name: {{ openvpn_map.confdir }}/{{ openvpn_map.scriptdir }}/{{ openvpn_map.scripts.route_filter }}
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 700
    - source: salt://states/openvpn/contrib/scripts/{{ openvpn_map.scripts.route_filter }}
    - require:
      - file: openvpn-client-scriptdir

{% else %}
openvpn-client-scriptdir:
  file.absent:
    - name: {{ openvpn_map.confdir }}/{{ openvpn_map.scriptdir }}
{% endif %}
