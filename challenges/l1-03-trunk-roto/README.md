# El trunk que no troncaba

```
 pc1 10.0.0.1 (V10) ──ether3──┐                ┌──ether3── pc2 10.0.0.2 (V10)
                               sw1 ══ether2══ sw2
 pc3 10.0.0.3 (V20) ──ether4──┘     (trunk)    └──ether4── pc4 10.0.0.4 (V20)
```

El becario montó dos switches unidos por un trunk. La VLAN 10 funciona, pero los de la VLAN 20 se
quejan de que no se ven. **Arréglalo sin romper el aislamiento entre VLANs.**

**Qué aprendes:** puertos trunk (tagged) vs. acceso (untagged), `pvid`, y a diagnosticar
comparando una VLAN que funciona con una que no.

Herramientas útiles: `/interface bridge vlan print`, `/interface bridge port print`,
`/interface bridge host print`, y `tcpdump -e -i eth1` en los PCs (`-e` muestra las MACs).

> Los PCs ya están bien configurados: el reto se resuelve en los switches, no los toques.
