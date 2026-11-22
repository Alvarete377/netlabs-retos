# Vecinos que no se hablan

```
 pc1 192.168.1.10/24                                                                          pc2 192.168.4.10/24
   gw 192.168.1.1                                                                               gw 192.168.4.1
        │                                                                                             │
     ether2                                                                                        ether3
       r1 ──ether3══════ether2── r2 ──ether3══════ether2── r3 ──ether3══════ether2── r4
            .1    172.16.12.0/30 .2   .1    172.16.23.0/30 .2   .1    172.16.34.0/30 .2

                                    todo en el área backbone (0.0.0.0)
```

Cuatro routers en cadena (`r1 – r2 – r3 – r4`) unen la LAN de `pc1` (`192.168.1.0/24`) con la LAN
de `pc2` (`192.168.4.0/24`). Todas las direcciones IP están bien puestas y los enlaces directos
responden al ping, pero **alguien tocó la configuración OSPF y ahora `pc1` y `pc2` no se ven**:
ninguna de las vecindades OSPF termina de levantarse.

Hay **tres fallos** repartidos por la cadena, cada uno en un router distinto, y cada uno basta por
sí solo para cortar la red.

**Cómo debería estar la red:**

- Los cuatro routers hablan **OSPF** en el **área backbone (`0.0.0.0`)**.
- Cada enlace entre routers (`r1–r2`, `r2–r3` y `r3–r4`) debe formar una vecindad OSPF en estado
  `Full`.
- `r1` debe aprender `192.168.4.0/24` por OSPF y `r4` debe aprender `192.168.1.0/24` por OSPF,
  todo dentro del backbone.

**Objetivo:** encontrar y corregir los fallos de OSPF para que todas las vecindades lleguen a
`Full` y `pc1` y `pc2` se hagan ping en ambos sentidos.

**Reglas generales:**

- **Cero rutas estáticas** en los cuatro routers: las rutas deben aprenderse por OSPF.
- **Sin NAT** en ningún router.
- Todos los routers en el **área backbone (`0.0.0.0`)**.

**Qué aprendes:**

- Diagnosticar por qué dos routers OSPF **no se hacen vecinos**: comparar extremo a extremo los
  parámetros que OSPF exige que coincidan (*área*, *hello/dead intervals*, modo *passive*, subred y
  tipo de red).
- Usar un método sistemático enlace por enlace en lugar de adivinar, apoyándote en
  `/routing ospf neighbor print`, `/routing ospf interface-template print detail` y
  `/routing ospf interface print detail`.
- Distinguir cuándo `passive` es buena práctica (en una LAN sin routers vecinos) y cuándo rompe la
  red (en un enlace entre routers).

Herramientas útiles: `/routing ospf neighbor print`, `/routing ospf area print`,
`/routing ospf interface-template print detail`, `/routing ospf interface print detail`,
`/log print`, `/ip route print where ospf`, `/ping` y `traceroute` en los PCs.

`lab console r1` · `lab console r2` · `lab console r3` · `lab console r4` · `lab console pc1` · `lab check` · `lab hint`

> Los PCs ya están bien configurados: el reto se resuelve en los routers, no los toques. No uses NAT.
