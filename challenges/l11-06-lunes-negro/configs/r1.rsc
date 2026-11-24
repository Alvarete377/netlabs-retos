/system identity set name=r1
/ip address add address=192.168.1.1/24 interface=ether2 comment="LAN de la sede"
/ip address add address=172.16.12.1/30 interface=ether3 comment="enlace con el centro de datos"
/ip route add dst-address=192.168.20.0/24 gateway=172.16.12.2 comment="centro de datos"
/ip dns set servers=172.16.12.6 allow-remote-requests=yes
/ip dhcp-relay add name=sede interface=ether2 dhcp-server=172.16.12.6 local-address=192.168.1.1 disabled=no
