/system identity set name=r2
/ip address add address=172.16.12.2/30 interface=ether2
/ip address add address=172.16.23.1/30 interface=ether3
/ip route add dst-address=192.168.1.0/24 gateway=172.16.12.1
/ip route add dst-address=192.168.3.0/24 gateway=172.16.23.3