/system identity set name=r1
/ip address add address=100.64.1.2/30 interface=ether2 comment="isp1 (AS 65101)"
/ip address add address=100.64.2.2/30 interface=ether3 comment="isp2 (AS 65102)"
/ip address add address=203.0.113.1/25 interface=ether4 comment="oficina"
/ip address add address=203.0.113.129/25 interface=ether5 comment="DMZ (web)"
/ip route add dst-address=203.0.113.0/24 blackhole comment="agregado que se anuncia por BGP"
/ip firewall address-list add list=mis-redes address=203.0.113.0/24
/routing filter rule add chain=salida rule="if (dst in 203.0.113.0/24 && dst-len == 24) { accept } else { reject }"
/routing bgp connection add name=isp1 as=65000 router-id=203.0.113.1 local.role=ebgp remote.address=100.64.1.1 remote.as=65101 output.network=mis-redes output.filter-chain=salida
/routing bgp connection add name=isp2 as=65000 router-id=203.0.113.1 local.role=ebgp remote.address=100.64.2.1 remote.as=65102 output.network=mis-redes output.filter-chain=salida
