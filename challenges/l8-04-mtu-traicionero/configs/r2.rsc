/system identity set name=r2
/interface ethernet set [find default-name=ether2] mtu=1400 comment="enlace contratado con MTU 1400"
/ip address add address=10.0.12.2/30 interface=ether2
/ip address add address=10.0.23.1/30 interface=ether3
/ip route add dst-address=192.168.1.0/24 gateway=10.0.12.1
/ip route add dst-address=192.168.30.0/24 gateway=10.0.23.2
