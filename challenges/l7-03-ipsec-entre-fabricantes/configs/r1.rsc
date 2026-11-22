/system identity set name=r1
/ip address add address=192.168.1.1/24 interface=ether2 comment="LAN de la central"
/ip address add address=198.51.100.2/30 interface=ether3 comment="WAN de la central"
/ip route add dst-address=0.0.0.0/0 gateway=198.51.100.1
/ip firewall nat add chain=srcnat out-interface=ether3 action=masquerade comment="salida a Internet de la LAN"
/ip ipsec peer add name=filial address=203.0.113.2/32 exchange-mode=ike2 comment="montado con las propuestas por defecto"
/ip ipsec identity add peer=filial auth-method=pre-shared-key secret="Central-Filial-2026"
/ip ipsec policy add src-address=192.168.1.0/24 dst-address=192.168.2.0/24 peer=filial tunnel=yes
