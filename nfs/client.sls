{% from 'states/nfs/map.jinja' import nfs as nfs_map with context %}

nfs-client-packages:
  pkg.installed:
    - pkgs: {{ nfs_map.client.packages }}
