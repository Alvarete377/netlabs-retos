/system identity set name=r4
/ip address add address=10.0.34.2/30 interface=ether2 comment="hacia r3"
/ip address add address=192.168.4.1/24 interface=ether3 comment="LAN de la filial"
/routing rip instance add name=default redistribute=connected,rip
/routing rip interface-template add instance=default interfaces=ether2
