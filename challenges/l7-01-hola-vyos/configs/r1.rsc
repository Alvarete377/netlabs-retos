/system identity set name=r1
/ip address add address=192.168.1.1/24 interface=ether2 comment="LAN de la central"
/ip address add address=172.16.12.1/30 interface=ether3 comment="enlace con el router VyOS de la filial"
/ip route add dst-address=192.168.2.0/24 gateway=172.16.12.2 comment="LAN de la filial por el VyOS"
