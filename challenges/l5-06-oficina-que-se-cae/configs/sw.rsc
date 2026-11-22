/system identity set name=sw
/interface bonding add name=bond-r1 mode=balance-rr slaves=ether3,ether4 comment="dos cables hacia r1"
/interface bridge add name=br1
/interface bridge port add bridge=br1 interface=ether2 comment="pc1"
/interface bridge port add bridge=br1 interface=bond-r1 comment="r1 (dos cables)"
/interface bridge port add bridge=br1 interface=ether5 comment="r2"
