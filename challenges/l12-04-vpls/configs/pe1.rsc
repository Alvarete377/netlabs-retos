/system identity set name=pe1
/interface bridge add name=loopback comment="loopback"
/ip address add address=10.255.0.1/32 interface=loopback
/ip address add address=10.0.12.1/30 interface=ether2 comment="nucleo"
/routing ospf instance add name=nucleo router-id=10.255.0.1
/routing ospf area add name=backbone area-id=0.0.0.0 instance=nucleo
/routing ospf interface-template add area=backbone interfaces=ether2,loopback
/mpls interface add interface=all
/mpls ldp add afi=ip lsr-id=10.255.0.1 transport-addresses=10.255.0.1
/mpls ldp interface add interface=ether2
