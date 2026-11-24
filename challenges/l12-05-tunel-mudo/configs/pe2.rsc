/system identity set name=pe2
/interface bridge add name=loopback comment="loopback"
/ip address add address=10.255.0.3/32 interface=loopback
/ip address add address=10.0.23.2/30 interface=ether2 comment="nucleo"
/routing ospf instance add name=nucleo router-id=10.255.0.3
/routing ospf area add name=backbone area-id=0.0.0.0 instance=nucleo
/routing ospf interface-template add area=backbone interfaces=ether2,loopback
/mpls interface add interface=all
/mpls ldp add afi=ip lsr-id=10.255.0.3 transport-addresses=10.255.0.3
/mpls ldp interface add interface=ether2
/ip address add address=192.168.2.1/24 interface=ether3 comment="cliente A"
/routing bgp connection add name=vpn-pe1 as=65000 router-id=10.255.0.3 local.address=10.0.23.2 local.role=ibgp remote.address=10.255.0.1 remote.as=65000 address-families=vpnv4
/ip vrf add name=cliA interfaces=ether3
/routing bgp vpn add vrf=cliA route-distinguisher=65000:1 import.route-targets=65000:1 export.route-targets=65000:1 label-allocation-policy=per-vrf
