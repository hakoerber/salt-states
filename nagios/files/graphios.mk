extra_host_conf["_graphiteprefix"] = [
  ( "nagios", ALL_HOSTS),
]

extra_host_conf["_graphitepostfix"] = [
  ( "ping", ALL_HOSTS),
]

extra_service_conf["_graphiteprefix"] = [
  ( "nagios", ALL_HOSTS, ALL_SERVICES)
]

service_descriptions = {
#  "df": "df.%s",
#  "fs": "fs.%s",
#  "if": "if.%s",
}

extra_service_conf["_graphitepostfix"] = [
#  ( "check_mk", ALL_HOSTS, ["Check_MK"]),
#  ( "cpu.load", ALL_HOSTS, ["CPU load"]),
#  ( "cpu.utilization", ALL_HOSTS, ["CPU utilization"]),
  ( "disk.io", ALL_HOSTS, ["Disk IO SUMMARY"]),
#  ( "fs.root", ALL_HOSTS, ["fs_/$"]),
#  ( "fs.boot", ALL_HOSTS, ["fs_/boot$"]),
#  ( "fs.boot.efi", ALL_HOSTS, ["fs_/boot/efi$"]),
#  ( "fs.home", ALL_HOSTS, ["fs_/home$"]),
#  ( "fs.var", ALL_HOSTS, ["fs_/var$"]),
#  ( "interface.1", ALL_HOSTS, ["Interface1"]),
#  ( "interface.2", ALL_HOSTS, ["Interface2"]),
#  ( "interface.3", ALL_HOSTS, ["Interface3"]),
#  ( "interface.4", ALL_HOSTS, ["Interface4"]),
#  ( "interface.5", ALL_HOSTS, ["Interface5"]),
#  ( "interface.6", ALL_HOSTS, ["Interface6"]),
#  ( "interface.8", ALL_HOSTS, ["Interface8"]),
#  ( "kernel.context_switches", ALL_HOSTS, ["Kernel Context Switches"]),
#  ( "kernel.major_page_faults", ALL_HOSTS, ["Kernel Major Page Faults"]),
#  ( "kernel.process_creations", ALL_HOSTS, ["Kernel Process Creations"]),
#  ( "logins", ALL_HOSTS, ["Logins"]),
#  ( "memory.used", ALL_HOSTS, ["Memory used"]),
#  ( "threads", ALL_HOSTS, ["Number of threads"]),
#  ( "postfix.queue", ALL_HOSTS, ["Postfix Queue"]),
#  ( "tcp_connections", ALL_HOSTS, ["TCP Connections"]),
#  ( "temperature.0", ALL_HOSTS, ["Temperature 0"]),
#  ( "uptime", ALL_HOSTS, ["Uptime"]),
]
#

