/system identity set name=r3
/ip address add address=10.0.23.2/30 interface=ether2
/ip address add address=10.0.34.1/30 interface=ether3
/ip route add dst-address=192.168.4.0/24 gateway=10.0.34.2 comment="LAN de pc2"
