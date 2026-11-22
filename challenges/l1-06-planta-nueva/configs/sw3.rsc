/system identity set name=sw3
/interface bridge add name=br1 protocol-mode=rstp priority=0x1000 vlan-filtering=no
/interface bridge port add bridge=br1 interface=ether2
/interface bridge port add bridge=br1 interface=ether3
/interface bridge port add bridge=br1 interface=ether4 pvid=20
/interface bridge vlan add bridge=br1 vlan-ids=10 tagged=ether2,ether3
/interface bridge vlan add bridge=br1 vlan-ids=20 tagged=ether2,ether3 untagged=ether4
/interface bridge vlan add bridge=br1 vlan-ids=30 tagged=ether2,ether3
/interface bridge set br1 vlan-filtering=yes
