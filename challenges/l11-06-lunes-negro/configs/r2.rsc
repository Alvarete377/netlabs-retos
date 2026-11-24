/system identity set name=r2
/ip address add address=172.16.12.2/30 interface=ether2 comment="enlace con la sede"
/ip address add address=192.168.20.1/24 interface=ether3 comment="servidores"
/ip route add dst-address=192.168.1.0/24 gateway=172.16.12.1 comment="sede"
/ip dns set allow-remote-requests=yes
/ip dns static add name=intranet.empresa.lab address=192.168.20.10 comment="DNS del centro de datos"
/ip dns static add name=www.netlabs.lab address=198.51.100.80
/ip pool add name=sede1 ranges=192.168.1.100-192.168.1.199 comment="direcciones para la sede 1"
/ip dhcp-server network add address=192.168.1.0/24 gateway=192.168.1.1 dns-server=192.168.1.1 comment="sede 1"
/ip dhcp-server add name=central interface=ether2 relay=192.168.10.1 address-pool=sede1 lease-time=1m disabled=no
/ip firewall filter add chain=input in-interface=ether1 action=accept comment="LABORATORIO: gestion de lab, no tocar"
/ip firewall filter add chain=input connection-state=established,related action=accept comment="respuestas"
/ip firewall filter add chain=input protocol=icmp action=accept comment="ping"
/ip firewall filter add chain=input in-interface=ether2 protocol=udp dst-port=53,123 action=accept comment="servicios para las sedes"
/ip firewall filter add chain=input action=drop comment="nada mas"
