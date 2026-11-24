/system identity set name=r1
/ip address add address=10.0.0.1/24 interface=ether2 comment="red de gestión (mon)"
/ip address add address=10.0.1.1/24 interface=ether3 comment="servidores"
/snmp set location="CPD planta 0" contact="noc@empresa.lab"
