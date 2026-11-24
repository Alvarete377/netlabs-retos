/system identity set name=r2
/ip address add address=172.16.12.2/30 interface=ether2 comment="enlace con la sede"
/ip address add address=192.168.20.1/24 interface=ether3 comment="servidores"
/ip route add dst-address=192.168.1.0/24 gateway=172.16.12.1 comment="sede"
/ip pool add name=sede1 ranges=192.168.1.100-192.168.1.199 comment="direcciones para la sede 1"
/ip dhcp-server network add address=192.168.1.0/24 gateway=192.168.1.1 dns-server=192.168.20.53 comment="sede 1"
