/system identity set name=r1
/ip address add address=192.168.1.1/24 interface=ether2 comment=LAN
/ip address add address=198.51.100.2/30 interface=ether3 comment="WAN (la IP publica que te da el proveedor)"
/ip route add dst-address=0.0.0.0/0 gateway=198.51.100.1 comment="salida a Internet por el proveedor"
