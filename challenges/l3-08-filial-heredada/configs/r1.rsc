/system identity set name=r1
/ip address add address=192.168.1.1/24 interface=ether2 comment="LAN de la central"
/ip address add address=10.0.12.1/30 interface=ether3 comment="troncal hacia r2"
/routing ospf instance add name=default router-id=10.255.255.1
/routing ospf area add name=backbone area-id=0.0.0.0 instance=default
/routing ospf interface-template add area=backbone networks=10.0.12.0/30
/routing ospf interface-template add area=backbone networks=192.168.1.0/24 passive
