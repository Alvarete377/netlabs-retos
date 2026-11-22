/system identity set name=r1
/ip address add address=192.168.1.1/24 interface=ether2 comment="LAN sede 1"
/ip address add address=198.51.100.2/30 interface=ether3 comment="WAN sede 1 (IP publica)"
/ip route add dst-address=0.0.0.0/0 gateway=198.51.100.1 comment="salida a Internet"
/ip firewall nat add chain=srcnat out-interface=ether3 action=masquerade comment="salida a Internet de la LAN"

/interface wireguard add name=wg-sedes listen-port=51820 private-key="aDLKDUe0xuj2MgtzeymjLFokt8F2SA26XXzImEFHO04=" comment="central: espera a las sedes"
/interface wireguard peers add interface=wg-sedes public-key="0RiUhIzAo5ek9sv9o2d/Nj6f+coIMPuKm1m2yaGWOi4=" allowed-address=10.255.1.2/32,192.168.2.0/24 comment="sede 2"
/ip address add address=10.255.1.1/30 interface=wg-sedes comment="extremo del tunel en la central"
/ip firewall filter add chain=input in-interface=ether1 action=accept comment="LABORATORIO: gestion de NetLabs por ether1. No la toques ni pongas reglas encima."
/ip firewall filter add chain=input connection-state=established,related action=accept
/ip firewall filter add chain=input connection-state=invalid action=drop
/ip firewall filter add chain=input protocol=icmp action=accept
/ip firewall filter add chain=input in-interface=ether2 action=accept comment="administracion desde la LAN"
/ip firewall filter add chain=input action=drop comment="todo lo demas, fuera"
