/system identity set name=r1
/ip address add address=192.168.1.1/24 interface=ether2 comment=LAN
/ip address add address=203.0.113.1/24 interface=ether3 comment=Internet
/ip firewall filter add chain=input in-interface=ether1 action=accept comment="LABORATORIO: gestion de NetLabs por ether1. No la toques ni pongas reglas encima."
