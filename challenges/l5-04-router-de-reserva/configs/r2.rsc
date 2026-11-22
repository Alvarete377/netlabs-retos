/system identity set name=r2
/ip address add address=192.168.1.3/24 interface=ether2 comment="LAN (IP propia de r2)"
/ip address add address=198.51.100.6/30 interface=ether3 comment="salida a Internet de r2"
/ip route add dst-address=0.0.0.0/0 gateway=198.51.100.5
/ip firewall nat add chain=srcnat out-interface=ether3 action=masquerade
