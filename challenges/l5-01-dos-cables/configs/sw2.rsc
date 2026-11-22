/system identity set name=sw2
/interface bridge add name=br1 protocol-mode=rstp
/interface bridge port add bridge=br1 interface=ether2
/interface bridge port add bridge=br1 interface=ether3
/interface bridge port add bridge=br1 interface=ether4
