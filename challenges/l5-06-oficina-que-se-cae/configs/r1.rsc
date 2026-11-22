/system identity set name=r1
/interface bonding add name=bond-lan mode=802.3ad slaves=ether2,ether3 lacp-rate=1sec comment="dos cables hacia el switch"
/ip address add address=192.168.1.2/24 interface=bond-lan comment="LAN (IP propia de r1)"
/interface vrrp add name=vrrp1 interface=bond-lan vrid=10 priority=200 comment="r1 es el principal"
/ip address add address=192.168.1.1/32 interface=vrrp1 comment="puerta de enlace virtual"
/ip address add address=198.51.100.2/30 interface=ether4 comment="salida a Internet de r1"
/ip route add dst-address=0.0.0.0/0 gateway=198.51.100.1
/ip firewall nat add chain=srcnat out-interface=ether4 action=masquerade
/ip pool add name=lan ranges=192.168.1.100-192.168.1.199
/ip dhcp-server add name=dhcp-lan interface=bond-lan address-pool=lan lease-time=1m disabled=no comment="concesiones cortas: los PCs renuevan cada 30 s"
/ip dhcp-server network add address=192.168.1.0/24 gateway=192.168.1.2 dns-server=192.168.1.1
