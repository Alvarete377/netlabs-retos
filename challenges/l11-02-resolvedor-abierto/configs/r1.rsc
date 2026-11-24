/system identity set name=r1
/ip address add address=203.0.113.1/24 interface=ether2 comment="WAN (Internet)"
/ip address add address=192.168.1.1/24 interface=ether3 comment="oficina"
/ip dns set allow-remote-requests=yes
/ip dns static add name=intranet.empresa.lab address=192.168.20.10
/ip dns static add name=correo.empresa.lab address=192.168.20.25
/ip firewall filter add chain=input in-interface=ether1 action=accept comment="LABORATORIO: gestion de lab, no tocar"
/ip firewall filter add chain=input connection-state=established,related action=accept comment="respuestas"
/ip firewall filter add chain=input protocol=icmp action=accept comment="ping"
/ip firewall filter add chain=input protocol=udp dst-port=53 action=accept comment="DNS (lo pidio soporte)"
/ip firewall filter add chain=input in-interface=ether3 action=accept comment="la oficina gestiona r1"
/ip firewall filter add chain=input in-interface=ether2 protocol=udp action=drop comment="bloquear Internet"
