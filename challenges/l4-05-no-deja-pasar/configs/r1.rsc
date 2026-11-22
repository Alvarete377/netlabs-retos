/system identity set name=r1
/ip address add address=192.168.1.1/24 interface=ether2 comment="LAN (empleados)"
/ip address add address=198.51.100.1/24 interface=ether3 comment="DMZ (servidores publicos)"
/ip address add address=203.0.113.1/24 interface=ether4 comment="Internet"
/ip firewall filter add chain=input in-interface=ether1 action=accept comment="LABORATORIO: gestion de NetLabs por ether1. No la toques ni pongas reglas encima."
/ip firewall filter add chain=input connection-state=established,related action=accept
/ip firewall filter add chain=input connection-state=invalid action=drop
/ip firewall filter add chain=input protocol=icmp action=accept
/ip firewall filter add chain=input in-interface=ether2 action=accept
/ip firewall filter add chain=input action=drop comment="el router en si ya esta protegido"
/ip firewall nat add chain=srcnat src-address=192.168.1.0/24 out-interface=ether3 action=masquerade comment="la LAN sale a Internet"
/ip firewall filter add chain=forward in-interface=ether2 action=accept comment="LAN -> donde sea"
/ip firewall filter add chain=forward connection-state=invalid action=drop
/ip firewall filter add chain=forward in-interface=ether3 action=accept comment="DMZ -> Internet"
/ip firewall filter add chain=forward action=drop comment="todo lo demas, fuera"
/ip firewall filter add chain=forward in-interface=ether4 out-interface=ether3 protocol=tcp dst-port=80 action=accept comment="Internet -> web de la DMZ"
