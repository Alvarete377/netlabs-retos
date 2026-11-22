/system identity set name=r2
/ip address add address=192.168.1.3/24 interface=ether2 comment="LAN (IP propia de r2)"
/interface vrrp add name=vrrp1 interface=ether2 vrid=20 priority=250 comment="r2 es el de reserva"
/ip address add address=192.168.1.1/32 interface=vrrp1 comment="puerta de enlace virtual"
/ip address add address=198.51.100.6/30 interface=ether3 comment="salida a Internet de r2"
/ip route add dst-address=0.0.0.0/0 gateway=198.51.100.5
/ip firewall nat add chain=srcnat out-interface=ether3 action=masquerade
