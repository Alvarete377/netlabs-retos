/system identity set name=r1
/ip address add address=192.168.1.1/24 interface=ether2 comment="LAN de administracion"
/ip address add address=192.168.20.1/24 interface=ether3 comment="red de servidores"
/ip firewall filter add chain=forward connection-state=established,related action=accept comment="respuestas"
/ip firewall filter add chain=forward connection-state=invalid action=drop comment="invalidos"
/ip firewall filter add chain=forward protocol=tcp dst-port=3306,8181 action=drop comment="servicios internos: nunca desde fuera de la red de servidores"
/ip firewall filter add chain=forward in-interface=ether2 action=accept comment="la LAN de administracion llega a los servidores"
/ip firewall filter add chain=forward action=drop comment="todo lo demas, fuera"
