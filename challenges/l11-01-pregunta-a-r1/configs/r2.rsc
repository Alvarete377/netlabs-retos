/system identity set name=r2
/ip address add address=172.16.12.2/30 interface=ether2 comment="enlace con la sede"
/ip route add dst-address=192.168.1.0/24 gateway=172.16.12.1 comment="sede"
/ip dns set allow-remote-requests=yes
/ip dns static add name=intranet.empresa.lab address=192.168.20.10 comment="DNS del centro de datos"
/ip dns static add name=www.netlabs.lab address=198.51.100.80
