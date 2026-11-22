/system identity set name=r2
/ip address add address=10.0.12.2/30 interface=ether2 comment="troncal hacia r1 (area 0)"
/ip address add address=10.0.23.1/30 interface=ether3 comment="hacia la filial (area 1)"
/routing ospf instance add name=default router-id=10.255.255.2
/routing ospf area add name=backbone area-id=0.0.0.0 instance=default
/routing ospf area add name=area1 area-id=0.0.0.1 instance=default type=stub comment="area de la filial: sin externas del resto"
/routing ospf interface-template add area=backbone networks=10.0.12.0/30 hello-interval=5s
/routing ospf interface-template add area=backbone networks=10.0.23.0/30
