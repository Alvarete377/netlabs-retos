/system identity set name=sw4
/interface bridge add name=br1 protocol-mode=rstp priority=0x8000 vlan-filtering=no
/interface bridge port add bridge=br1 interface=ether2
/interface bridge port add bridge=br1 interface=ether3 frame-types=admit-only-untagged-and-priority-tagged
/interface bridge port add bridge=br1 interface=ether4 pvid=20
/interface bridge port add bridge=br1 interface=ether5 pvid=30
/interface bridge vlan add bridge=br1 vlan-ids=10 tagged=ether2,ether3
/interface bridge vlan add bridge=br1 vlan-ids=20 tagged=ether2,ether3 untagged=ether4
/interface bridge vlan add bridge=br1 vlan-ids=30 tagged=ether2,ether3 untagged=ether5
/interface bridge set br1 vlan-filtering=yes
