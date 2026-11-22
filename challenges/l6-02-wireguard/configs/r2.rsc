/system identity set name=r2
/ip address add address=192.168.2.1/24 interface=ether3 comment="LAN sede 2"
/ip address add address=203.0.113.2/30 interface=ether2 comment="WAN sede 2 (IP publica)"
/ip route add dst-address=0.0.0.0/0 gateway=203.0.113.1 comment="salida a Internet"
/ip firewall nat add chain=srcnat out-interface=ether2 action=masquerade comment="salida a Internet de la LAN"
/interface wireguard add name=wg-sedes listen-port=51820 private-key="GGzobwWxp23z/9wB8xNohJD87lxQ1Ub6vS5wNZ4VsHo=" comment="WireGuard de la sede 2 (ya con sus claves)"
