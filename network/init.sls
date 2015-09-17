#!stateconf

.params:
    stateconf.set: []
# --- end of state config ---

network-system:
  network.system:
    - enabled: True
    - hostname: {{ params.hostname }}
    - order: last

{% for interface in params.interfaces %}
network-interface-{{ interface.name }}:
  network.managed:
    - name: {{ interface.name }}
    - type: {{ interface.type }}
    - enabled: True

    # MAC address
    - addr: {{ interface.mac }}

    {% if interface.mode == 'dhcp' %}
    - proto: dhcp
    {% else %}
    - proto: none
    - ipaddr: {{ interface.address }}
    - netmask: {{ interface.netmask }}
    - dns: {{ interface.nameservers }}
    - gateway: {{ interface.gateway }}
    {% endif %}

    - order: last
{% endfor %}
