/system identity set name=r1
/ip address add address=192.168.1.1/24 interface=ether2 comment="LAN de pc1"
/ip address add address=10.0.12.1/30 interface=ether3
/ip route add dst-address=0.0.0.0/0 gateway=10.0.12.2 comment="todo lo demas, hacia r2"
