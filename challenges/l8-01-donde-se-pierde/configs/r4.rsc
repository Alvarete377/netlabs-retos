/system identity set name=r4
/ip address add address=10.0.34.2/30 interface=ether2
/ip address add address=192.168.4.1/24 interface=ether3 comment="LAN de pc2"
/ip route add dst-address=0.0.0.0/0 gateway=10.0.34.1 comment="todo lo demas, hacia r3"
