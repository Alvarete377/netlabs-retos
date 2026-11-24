/system identity set name=r3
/ip address add address=10.0.23.2/30 interface=ether2
/ip address add address=192.168.30.1/24 interface=ether3 comment="red de servidores"
/ip route add dst-address=0.0.0.0/0 gateway=10.0.23.1
/ip firewall filter add chain=forward protocol=icmp action=drop comment="por seguridad, nada de ICMP"
/ip firewall filter add chain=forward connection-state=established,related action=accept comment="respuestas"
/ip firewall filter add chain=forward connection-state=invalid action=drop comment="invalidos"
/ip firewall filter add chain=forward protocol=tcp dst-port=80 dst-address=192.168.30.10 action=accept comment="web de informes"
/ip firewall filter add chain=forward in-interface=ether3 action=accept comment="los servidores salen"
/ip firewall filter add chain=forward action=drop comment="todo lo demas, fuera"
