extra_host_conf["_graphiteprefix"] = [
  ( "nagios", ALL_HOSTS),
]

extra_host_conf["_graphitepostfix"] = [
  ( "ping", ALL_HOSTS),
]

extra_service_conf["_graphiteprefix"] = [
  ( "nagios", ALL_HOSTS, ALL_SERVICES)
]

extra_service_conf["_graphitepostfix"] = []
