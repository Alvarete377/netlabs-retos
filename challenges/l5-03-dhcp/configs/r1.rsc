/system identity set name=r1
/interface bridge add name=lan comment="LAN de la oficina"
/interface bridge port add bridge=lan interface=ether2
/interface bridge port add bridge=lan interface=ether3
/ip address add address=192.168.1.1/24 interface=lan comment=LAN
/ip address add address=203.0.113.1/24 interface=ether4 comment=Internet
/ip firewall nat add chain=srcnat out-interface=ether4 action=masquerade comment="salida a Internet"
