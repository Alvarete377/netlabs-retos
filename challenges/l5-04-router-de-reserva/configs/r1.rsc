/system identity set name=r1
/ip address add address=192.168.1.2/24 interface=ether2 comment="LAN (IP propia de r1)"
/ip address add address=198.51.100.2/30 interface=ether3 comment="salida a Internet de r1"
/ip route add dst-address=0.0.0.0/0 gateway=198.51.100.1
/ip firewall nat add chain=srcnat out-interface=ether3 action=masquerade
