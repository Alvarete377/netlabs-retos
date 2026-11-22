/system identity set name=r1
/interface bridge add name=lan comment="LAN de la sucursal"
/interface bridge port add bridge=lan interface=ether2
/interface bridge port add bridge=lan interface=ether3
/ip address add address=192.168.1.1/24 interface=lan comment=LAN
/ip pool add name=lan ranges=192.168.1.100-192.168.1.199
/ip dhcp-server add name=dhcp-lan interface=lan address-pool=lan lease-time=1m disabled=no comment="concesiones cortas: los PCs renuevan cada 30 s"
/ip dhcp-server network add address=192.168.1.0/24 gateway=192.168.1.254 dns-server=192.168.1.1 comment="red de la LAN"
/ip dns set allow-remote-requests=yes
/interface pppoe-client add name=pppoe-out1 interface=ether4 user=sucursal password=Fibra2O26 add-default-route=no disabled=no comment="fibra del proveedor"
/ip firewall nat add chain=srcnat out-interface=ether4 action=masquerade comment="salida a Internet"
