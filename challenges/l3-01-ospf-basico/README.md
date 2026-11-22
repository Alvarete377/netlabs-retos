# Que se descubran solos

```
 pc1 192.168.1.10/24                                                   pc2 192.168.3.10/24
   gw 192.168.1.1                                                        gw 192.168.3.1
        │                                                                      │
     ether2                                                                 ether3
       r1 ──ether3════════════════ether2── r2 ──ether3════════════════ether2── r3
            .1/30  172.16.12.0/30  .2/30        .1/30  172.16.23.0/30  .2/30

                           todo en el área backbone (0.0.0.0)
```

Tres routers en cadena: r1 (con la LAN de pc1), r2 (el del medio) y r3 (con la LAN de pc2). Todas
las direcciones IP están puestas, pero **no hay ni una ruta**: cada router sólo conoce sus redes
conectadas, así que pc1 y pc2 no se ven.

En el nivel 2 lo habrías arreglado con rutas estáticas, una a una y en cada router. Esta vez no:
la empresa va a crecer y nadie quiere mantener rutas a mano. Los routers tienen que **descubrirse
solos** y contarse qué redes tienen, con **OSPF**.

**Objetivo:** activar OSPF en los tres routers, todo en el **área backbone** (`0.0.0.0`), para que
pc1 y pc2 se hagan ping en los dos sentidos.

**Qué hay que conseguir, y qué se rechaza:**

- r2 debe tener **dos vecinos OSPF en estado `Full`** (r1 y r3).
- r1 debe aprender la LAN de pc2 (`192.168.3.0/24`) **por OSPF**, y r3 la de pc1 (`192.168.1.0/24`).
- **Cero rutas estáticas** en los tres routers: todas las rutas remotas las pone OSPF.
- **Sin NAT** en ningún router.

**Qué aprendes:**

- Qué es un **protocolo de enrutamiento dinámico**: los routers intercambian información y
  construyen sus tablas de rutas solos; si la red cambia, se recalculan sin tocar nada.
- Cómo funciona OSPF a grandes rasgos: **vecinos** que se descubren con paquetes *Hello*, que
  llegan al estado **`Full`** y que comparten un mapa de la red (LSAs) sobre el que cada router
  calcula el camino más corto.
- Las piezas de OSPF en RouterOS 7: **instancia** (con su *router-id*), **área** e
  **interface-template** (en qué redes/interfaces se habla OSPF).

Herramientas útiles: `/routing ospf instance print`, `/routing ospf interface print`,
`/routing ospf neighbor print`, `/ip route print` (las rutas de OSPF llevan la flag `o`), `ping` y
`traceroute` en los PCs.

`lab console r1` · `lab console r2` · `lab console r3` · `lab console pc1` · `lab check` · `lab hint`

> Los PCs ya están bien configurados: el reto se resuelve en los routers, no los toques. No uses NAT.
