/system identity set name=r3
/ip address add address=172.16.13.2/30 interface=ether2 comment="4G hacia la sucursal"
/ip address add address=172.16.23.2/30 interface=ether3 comment="red del operador (r2)"
/ip route add dst-address=192.168.1.0/24 gateway=172.16.13.1 comment="sucursal"
/ip route add dst-address=192.168.99.0/24 gateway=172.16.23.1 comment="servidores"
