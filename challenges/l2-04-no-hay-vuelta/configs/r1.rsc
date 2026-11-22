/system identity set name=r1
/ip address add address=192.168.1.1/24 interface=ether2
/ip address add address=172.16.12.1/30 interface=ether3
/ip route add dst-address=0.0.0.0/0 gateway=172.16.12.2
/ip route add dst-address=192.168.3.0/24 blackhole comment="prueba antigua"