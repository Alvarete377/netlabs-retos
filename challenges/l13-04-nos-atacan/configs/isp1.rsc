/system identity set name=isp1
/ip address add address=100.64.1.1/30 interface=ether2 comment="cliente (r1)"
/ip address add address=100.64.12.1/30 interface=ether3 comment="isp2"
/ip address add address=198.51.100.1/24 interface=ether4 comment="sus servidores"
/ip firewall address-list add list=isp1-redes address=198.51.100.0/24
/routing bgp connection add name=cliente as=65101 router-id=100.64.1.1 local.role=ebgp remote.address=100.64.1.2 remote.as=65000 output.network=isp1-redes input.filter=desde-cliente
/routing bgp connection add name=isp2 as=65101 router-id=100.64.1.1 local.role=ebgp remote.address=100.64.12.2 remote.as=65102 output.network=isp1-redes
/routing filter rule add chain=desde-cliente rule="if (dst in 203.0.113.0/24 && dst-len == 32 && bgp-communities includes 65101:666) { set blackhole yes; accept }" comment="RTBH: blackhole remoto para clientes"
/routing filter rule add chain=desde-cliente rule="if (dst in 203.0.113.0/24 && dst-len == 24) { accept }" comment="prefijo del cliente"
/routing filter rule add chain=desde-cliente rule="reject"
