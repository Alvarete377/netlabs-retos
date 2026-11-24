/system identity set name=r2
/ip address add address=172.16.12.2/30 interface=ether2 comment="enlace con r1"
/ip route add gateway=172.16.12.1 comment="todo por r1"
/snmp set enabled=yes location="Nave 2" contact="noc@empresa.lab"
/snmp community add name=netlabs-ro addresses=10.0.0.100/32
/snmp community set [find default=yes] disabled=yes
/system logging action set [find name=remote] remote=10.0.0.10
/system logging add topics=info action=remote
/ip firewall filter add chain=input in-interface=ether1 action=accept comment="LABORATORIO: gestion de lab, no tocar"
/ip firewall filter add chain=input connection-state=established,related action=accept
/ip firewall filter add chain=input protocol=icmp action=accept
/ip firewall filter add chain=input src-address=10.0.0.10 protocol=tcp dst-port=22,8291 action=accept comment="gestion desde mon"
/ip firewall filter add chain=input action=drop comment="todo lo demas"
