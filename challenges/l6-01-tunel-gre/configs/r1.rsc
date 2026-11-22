/system identity set name=r1
/ip address add address=192.168.1.1/24 interface=ether2 comment="LAN sede 1"
/ip address add address=198.51.100.2/30 interface=ether3 comment="WAN sede 1 (IP publica)"
/ip route add dst-address=0.0.0.0/0 gateway=198.51.100.1 comment="salida a Internet"
/ip firewall nat add chain=srcnat out-interface=ether3 action=masquerade comment="salida a Internet de la LAN"
