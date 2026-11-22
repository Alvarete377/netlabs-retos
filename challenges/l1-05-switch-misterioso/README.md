# El switch misterioso

```
 VLAN 10  pc1 .1 ─ether3─┐                                  ┌─ether3─ pc2 .2  VLAN 10
                          sw1 ══ether2══ sw2 ══ether3══ sw3
 VLAN 20  pc3 .3 ─ether4─┘    (trunk)  (tránsito) (trunk)   └─ether4─ pc4 .4  VLAN 20
```

Los cuatro PCs están en la misma subred, `192.168.10.0/24`, pero en dos VLANs distintas: pc1 y pc2
en la VLAN 10, pc3 y pc4 en la VLAN 20. Así que **lo único que los separa es la capa 2**.

Tres switches en cadena. sw2 sólo hace de tránsito entre sw1 y sw3. Un compañero "limpió" la
configuración de sw2 y sw3 y desde entonces **ninguna de las dos VLANs llega de un extremo al otro**.
Arréglalo sin romper el aislamiento: pc1/pc2 no deben ver a pc3/pc4.

**Qué aprendes:** seguir una trama salto a salto, `pvid`, `frame-types`, `ingress-filtering`, y la
diferencia entre pertenecer a una VLAN como tagged o untagged.

Herramientas útiles: `/interface bridge port print detail`, `/interface bridge vlan print`,
`/interface bridge host print`, y `tcpdump -e -i eth1` en los PCs (`-e` muestra las MACs y, si las
hay, las etiquetas).

> Los PCs ya están bien configurados: el reto se resuelve en los switches, no los toques.
