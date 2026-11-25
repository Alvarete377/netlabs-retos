/system identity set name=r2
/ip address add address=172.16.12.2/30 interface=ether2 comment="fibra hacia la sucursal"
/ip address add address=172.16.23.1/30 interface=ether3 comment="red del operador (r3)"
/ip address add address=192.168.99.1/24 interface=ether4 comment="servidores"
/ip route add dst-address=192.168.1.0/24 gateway=172.16.12.1 comment="sucursal por la fibra"
/ip route add dst-address=192.168.1.0/24 gateway=172.16.23.2 distance=2 comment="sucursal por el 4G"
/interface disable ether2
