/system identity set name=sw2
/interface bridge add name=br1 vlan-filtering=no
/interface bridge port add bridge=br1 interface=ether2
/interface bridge port add bridge=br1 interface=ether3 frame-types=admit-only-untagged-and-priority-tagged
/interface bridge vlan add bridge=br1 vlan-ids=10 tagged=ether2
/interface bridge vlan add bridge=br1 vlan-ids=20 tagged=ether2,ether3
/interface bridge set br1 vlan-filtering=yes