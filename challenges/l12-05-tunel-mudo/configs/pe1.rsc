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
/ip address add address=192.168.1.1/24 interface=ether3 comment="cliente A"
/routing bgp connection add name=vpn-pe2 as=65000 router-id=10.255.0.1 local.address=10.255.0.1 local.role=ibgp remote.address=10.255.0.3 remote.as=65000 address-families=vpnv4
/ip vrf add name=cliA interfaces=ether3
/routing bgp vpn add vrf=cliA route-distinguisher=65000:1 import.route-targets=65000:2 export.route-targets=65000:1 export.redistribute=connected label-allocation-policy=per-vrf
