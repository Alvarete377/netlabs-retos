/system identity set name=r2
/ip address add address=10.0.12.2/30 interface=ether2
/ip address add address=10.0.23.1/30 interface=ether3
/ip route add dst-address=192.168.1.0/24 gateway=10.0.12.1 comment="LAN de pc1"
/ip route add dst-address=0.0.0.0/0 gateway=10.0.23.2 comment="todo lo demas, hacia r3"
