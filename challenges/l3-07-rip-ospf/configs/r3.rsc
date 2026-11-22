/system identity set name=r3
/ip address add address=172.16.23.2/30 interface=ether2
/ip address add address=192.168.3.1/24 interface=ether3
/routing ospf instance add name=default router-id=10.255.255.3
/routing ospf area add name=backbone area-id=0.0.0.0 instance=default
/routing ospf interface-template add area=backbone networks=172.16.23.0/30
/routing ospf interface-template add area=backbone networks=192.168.3.0/24 passive
