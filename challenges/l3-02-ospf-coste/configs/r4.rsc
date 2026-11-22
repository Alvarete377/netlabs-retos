/system identity set name=r4
/ip address add address=172.16.24.2/30 interface=ether2
/ip address add address=172.16.34.2/30 interface=ether3
/ip address add address=192.168.4.1/24 interface=ether4
/routing ospf instance add name=default router-id=10.255.255.4
/routing ospf area add name=backbone area-id=0.0.0.0 instance=default
/routing ospf interface-template add area=backbone networks=172.16.24.0/30
/routing ospf interface-template add area=backbone networks=172.16.34.0/30
/routing ospf interface-template add area=backbone networks=192.168.4.0/24 passive
