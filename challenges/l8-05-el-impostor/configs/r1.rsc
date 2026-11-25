/system identity set name=r1
/interface bridge add name=bridge-lan comment="switch de la oficina"
/interface bridge port add bridge=bridge-lan interface=ether2
/interface bridge port add bridge=bridge-lan interface=ether3
/interface bridge port add bridge=bridge-lan interface=ether4
/ip address add address=192.168.1.1/24 interface=bridge-lan comment="LAN oficina"
/ip address add address=192.168.20.1/24 interface=ether5 comment="servidores"
