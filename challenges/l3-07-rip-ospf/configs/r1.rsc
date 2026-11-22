/system identity set name=r1
/ip address add address=192.168.1.1/24 interface=ether2
/ip address add address=172.16.12.1/30 interface=ether3
/routing rip instance add name=default redistribute=connected,rip
/routing rip interface-template add instance=default interfaces=ether3
