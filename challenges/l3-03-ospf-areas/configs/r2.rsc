/system identity set name=r2
/ip address add address=172.16.12.2/30 interface=ether2
/ip address add address=172.16.23.1/30 interface=ether3
/routing ospf instance add name=default router-id=10.255.255.2
/routing ospf area add name=backbone area-id=0.0.0.0 instance=default
/routing ospf interface-template add area=backbone networks=172.16.12.0/30
