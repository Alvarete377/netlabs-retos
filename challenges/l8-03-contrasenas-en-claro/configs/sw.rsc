/system identity set name=sw
/interface bridge add name=br1 comment="switch de la oficina"
/interface bridge port add bridge=br1 interface=ether2 learn=no comment="pc1 (contabilidad) - modo espejo para la auditoria"
/interface bridge port add bridge=br1 interface=ether3 learn=no comment="analista - modo espejo para la auditoria"
/interface bridge port add bridge=br1 interface=ether4 learn=no comment="hacia r1 - modo espejo para la auditoria"
