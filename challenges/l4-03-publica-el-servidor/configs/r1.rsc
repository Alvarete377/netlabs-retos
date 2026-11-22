/system identity set name=r1
/interface bridge add name=lan comment="LAN de la oficina (pc1 y el servidor web)"
/interface bridge port add bridge=lan interface=ether2
/interface bridge port add bridge=lan interface=ether3
/ip address add address=192.168.1.1/24 interface=lan comment=LAN
/ip address add address=203.0.113.1/24 interface=ether4 comment="WAN: IP publica de la oficina"
/ip firewall nat add chain=srcnat out-interface=ether4 action=masquerade comment="salida a Internet de la LAN"
/ip firewall filter add chain=input in-interface=ether1 action=accept comment="LABORATORIO: gestion de NetLabs por ether1. No la toques ni pongas reglas encima."
/ip firewall filter add chain=input connection-state=established,related action=accept
/ip firewall filter add chain=input connection-state=invalid action=drop
/ip firewall filter add chain=input protocol=icmp action=accept
/ip firewall filter add chain=input in-interface=lan action=accept
/ip firewall filter add chain=input action=drop comment="el router en si ya esta protegido (reto Cierra la puerta)"
