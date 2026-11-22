/system identity set name=r3
/ip address add address=10.0.23.2/30 interface=ether2 comment="hacia r2 (area 1)"
/ip address add address=10.0.34.1/30 interface=ether3 comment="hacia el router heredado (RIP)"
/routing ospf instance add name=default router-id=10.255.255.3 redistribute=rip
/routing ospf area add name=area1 area-id=0.0.0.1 instance=default type=stub comment="area de la filial: sin externas del resto"
/routing ospf interface-template add area=area1 networks=10.0.23.0/30
/routing rip instance add name=default redistribute=connected,rip
/routing rip interface-template add instance=default interfaces=ether3
