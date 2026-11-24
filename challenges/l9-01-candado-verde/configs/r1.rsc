/system identity set name=r1
/ip address add address=192.168.1.1/24 interface=ether2 comment="oficina"
/ip address add address=192.168.20.1/24 interface=ether3 comment="servidores"
/ip dns set allow-remote-requests=yes
/ip dns static add name=web.lab address=192.168.20.10 comment="intranet"
