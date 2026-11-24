/system identity set name=r1
/ipv6 nd set [find interface=all] ra-interval=10s-20s comment="LABORATORIO: anuncios cada 10-20 s para no esperar minutos"
/ipv6 address add address=2001:db8:12::1/64 interface=ether2 advertise=no comment="enlace con r2"
/ipv6 address add address=2001:db8:1::1/64 interface=ether3 advertise=yes comment="LAN de pc1"
