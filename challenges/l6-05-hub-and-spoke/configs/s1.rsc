/system identity set name=s1
/ip address add address=203.0.113.2/30 interface=ether2 comment="WAN de la sede 1"
/ip address add address=192.168.1.1/24 interface=ether3 comment="LAN de la sede 1"
/ip route add dst-address=0.0.0.0/0 gateway=203.0.113.1 comment="salida a Internet"
/ip firewall nat add chain=srcnat out-interface=ether2 action=masquerade comment="salida a Internet de la LAN"
/interface wireguard add name=wg-central listen-port=51820 private-key="WJOxysISbM82RgIlxRey23vrjQgPb8OBnur4jWgcc0c="
/ip address add address=10.255.0.2/24 interface=wg-central comment="red de los tuneles"
/interface wireguard peers add interface=wg-central public-key="ZBz+R5+H6lqV8lZNm6ZW73uEX4zXarbCEZDraBTzPwg=" endpoint-address=198.51.100.2 endpoint-port=51820 allowed-address=10.255.0.0/24,192.168.0.0/24 persistent-keepalive=25s comment="central"
/ip route add dst-address=192.168.0.0/24 gateway=10.255.0.1 comment="LAN de la central"
