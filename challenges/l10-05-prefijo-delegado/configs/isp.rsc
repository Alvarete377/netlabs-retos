/system identity set name=isp
/ipv6 address add address=2001:db8:f::1/64 interface=ether2 advertise=no comment="clientes (r1)"
/ipv6 address add address=2001:db8:ff::1/64 interface=ether3 advertise=no comment="Internet (srv)"
/ipv6 pool add name=clientes prefix=2001:db8:100::/40 prefix-length=56 comment="prefijos para delegar"
/ipv6 dhcp-server add name=pd interface=ether2 address-pool=clientes lease-time=1m comment="delegacion de prefijos"
