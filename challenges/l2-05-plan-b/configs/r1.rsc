/system identity set name=r1
/ip address add address=192.168.1.1/24 interface=ether2 comment="LAN sucursal"
/ip address add address=172.16.12.1/30 interface=ether3 comment="fibra (r2)"
/ip address add address=172.16.13.1/30 interface=ether4 comment="4G (r3)"
/ip route add dst-address=0.0.0.0/0 gateway=172.16.12.2 comment="salida por la fibra"
