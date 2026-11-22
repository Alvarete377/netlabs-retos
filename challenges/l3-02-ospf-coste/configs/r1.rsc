/system identity set name=r1
/ip address add address=192.168.1.1/24 interface=ether2
/ip address add address=172.16.12.1/30 interface=ether3
/ip address add address=172.16.13.1/30 interface=ether4
/routing ospf instance add name=default router-id=10.255.255.1
/routing ospf area add name=backbone area-id=0.0.0.0 instance=default
/routing ospf interface-template add area=backbone networks=172.16.12.0/30
/routing ospf interface-template add area=backbone networks=172.16.13.0/30
/routing ospf interface-template add area=backbone networks=192.168.1.0/24 passive
