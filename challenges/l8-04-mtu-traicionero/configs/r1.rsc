/system identity set name=r1
/ip address add address=192.168.1.1/24 interface=ether2 comment="LAN de la sucursal"
/interface ethernet set [find default-name=ether3] mtu=1400 comment="enlace contratado con MTU 1400"
/ip address add address=10.0.12.1/30 interface=ether3
/ip route add dst-address=0.0.0.0/0 gateway=10.0.12.2
