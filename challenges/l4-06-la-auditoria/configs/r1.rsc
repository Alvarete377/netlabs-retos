/system identity set name=r1
/interface bridge add name=lan comment="LAN de la oficina (pc1 y el servidor web)"
/interface bridge port add bridge=lan interface=ether2
/interface bridge port add bridge=lan interface=ether3
/ip address add address=192.168.1.1/24 interface=lan comment=LAN
/ip address add address=203.0.113.1/24 interface=ether4 comment="WAN: IP publica de la oficina"
/ip firewall nat add chain=srcnat out-interface=ether4 action=masquerade comment="salida a Internet de la LAN"
/ip firewall nat add chain=dstnat in-interface=lan protocol=tcp dst-port=80 action=dst-nat to-addresses=192.168.1.20 comment="publica la web de la oficina"
/ip firewall filter add chain=input in-interface=ether1 action=accept comment="LABORATORIO: gestion de NetLabs por ether1. No la toques ni pongas reglas encima."
/ip firewall filter add chain=input connection-state=established,related action=accept comment="respuestas"
/ip firewall filter add chain=input connection-state=invalid action=drop comment="invalidos"
/ip firewall filter add chain=input protocol=icmp action=accept comment="ping"
/ip firewall filter add chain=input protocol=tcp dst-port=22,8291 action=accept comment="gestion (SSH y Winbox)"
/ip firewall filter add chain=input in-interface=lan action=accept comment="la LAN puede usar el router"
/ip firewall filter add chain=input action=drop comment="al router, nada mas"
/ip firewall filter add chain=forward connection-state=established,related action=accept comment="respuestas"
/ip firewall filter add chain=forward connection-state=invalid action=drop comment="invalidos"
/ip firewall filter add chain=forward in-interface=lan action=accept comment="la LAN sale a donde quiera"
/ip firewall filter add chain=forward in-interface=ether4 action=drop comment="desde Internet no entra nada"
/ip firewall filter add chain=forward connection-nat-state=dstnat action=accept comment="lo publicado (web de la oficina)"
/ip firewall filter add chain=forward action=drop comment="todo lo demas, fuera"
