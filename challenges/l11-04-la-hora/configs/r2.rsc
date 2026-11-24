/system identity set name=r2
/ip address add address=172.16.12.2/30 interface=ether2 comment="enlace con la sede"
/ip route add dst-address=192.168.1.0/24 gateway=172.16.12.1 comment="sede"
/system ntp server set enabled=yes use-local-clock=yes local-clock-stratum=3
