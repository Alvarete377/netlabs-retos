/system identity set name=r1
/ip address add address=10.0.0.1/24 interface=ether2 comment="red de gestión (mon)"
/ip address add address=10.0.1.1/24 interface=ether3 comment="servidores"
/ip address add address=172.16.12.1/30 interface=ether5 comment="enlace con r2"
/snmp set location="CPD planta 0" contact="noc@empresa.lab"
/snmp set enabled=yes
/snmp community add name=netlabs-ro addresses=10.0.0.10/32
/snmp community set [find default=yes] disabled=yes
/system logging action set [find name=remote] remote=10.0.0.10
/system logging add topics=info action=remote
