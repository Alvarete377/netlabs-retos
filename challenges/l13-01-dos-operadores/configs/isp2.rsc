/system identity set name=isp2
/ip address add address=100.64.2.1/30 interface=ether2 comment="cliente (r1)"
/ip address add address=100.64.12.2/30 interface=ether3 comment="isp1"
/ip address add address=192.0.2.1/24 interface=lo comment="sus servidores"
/ip firewall address-list add list=isp2-redes address=192.0.2.0/24
/routing bgp connection add name=cliente as=65102 router-id=100.64.2.1 local.role=ebgp remote.address=100.64.2.2 remote.as=65000 output.network=isp2-redes
/routing bgp connection add name=isp1 as=65102 router-id=100.64.2.1 local.role=ebgp remote.address=100.64.12.1 remote.as=65101 output.network=isp2-redes
