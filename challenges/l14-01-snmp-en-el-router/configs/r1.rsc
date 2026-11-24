/system identity set name=r1
/ip address add address=10.0.0.1/24 interface=ether2 comment="red de gestión (mon)"
/ip address add address=192.168.50.1/24 interface=ether4 comment="oficina"
/snmp set location="CPD planta 0" contact="noc@empresa.lab"
