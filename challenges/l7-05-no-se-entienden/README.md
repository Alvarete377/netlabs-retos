# No se entienden

```
 pc1 192.168.1.10/24                                              pc2 192.168.2.10/24
   gw 192.168.1.1                                                   gw 192.168.2.1
        │                                                                │
     ether2                                                             eth2
       r1 (MikroTik) ──ether3── 172.16.12.1/30 ═ 172.16.12.2/30 ──eth1── vy1 (VyOS)
       central, AS 65001                                        filial, AS 65002
```

La central (MikroTik) y la nueva filial (VyOS) deberían intercambiar sus redes por **eBGP**. Lo
configuraron dos técnicos distintos, cada uno en su fabricante, y el resultado es que **pc1 y pc2 no
se ven**. Cada uno jura que su parte está bien.

**Datos acordados:** la central es el AS **65001** y anuncia `192.168.1.0/24`; la filial es el AS
**65002** y anuncia `192.168.2.0/24`.

**Objetivos:**

- Sesión eBGP establecida entre r1 y vy1.
- Cada router aprende por BGP la LAN real del otro, y pc1 y pc2 se ven en los dos sentidos.
- Sin rutas estáticas y sin cambiar los números de AS acordados.

**Qué aprendes:** a diagnosticar BGP entre fabricantes mirando **los dos lados**: estado de la sesión,
qué anuncia cada uno y qué acepta cada uno, con los comandos de RouterOS y de VyOS (FRR).

| | RouterOS | VyOS |
|---|---|---|
| Sesión | `/routing bgp session print` | `show ip bgp summary` |
| Detalle del vecino | `/routing bgp connection print detail` | `show ip bgp neighbors 172.16.12.1` |
| Rutas BGP | `/routing route print where bgp` | `show ip bgp` |
| Log | `/log print where topics~"bgp"` | `show log \| match bgp` |

`lab console r1` · `lab console vy1` · `lab check` · `lab hint`
