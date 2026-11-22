# El camino más corto no siempre es el mejor

```
                                172.16.12.0/30          172.16.24.0/30
                          .1/30       .2/30   ┌────┐   .1/30       .2/30
                     ┌─── ether3 ═════ ether2 ┤ r2 ├ ether3 ═════ ether2 ───┐
                     │                        └────┘                        │
                     │                 (línea de backup cara)               │
 pc1                 │                                                      │                 pc2
192.168.1.10/24    ┌─┴──┐                                                ┌──┴─┐    192.168.4.10/24
gw 192.168.1.1 ────┤ r1 │                                                │ r4 ├──── gw 192.168.4.1
             ether2└─┬──┘                                                └──┬─┘ether4
             .1/24   │                   (camino principal)                 │   .1/24
                     │                        ┌────┐                        │
                     └─── ether4 ═════ ether2 ┤ r3 ├ ether3 ═════ ether3 ───┘
                          .1/30       .2/30   └────┘   .1/30       .2/30
                                172.16.13.0/30          172.16.34.0/30

                               todo en el área backbone (0.0.0.0)
```

Cuatro routers formando un cuadrado: entre la sede de pc1 (`r1`) y la de pc2 (`r4`) hay **dos
caminos** — uno por arriba (`r1–r2–r4`) y otro por abajo (`r1–r3–r4`). **OSPF ya está funcionando**
en los cuatro routers, en el área backbone (`0.0.0.0`), con los costes por defecto (`cost=1` en
RouterOS 7): espera unos segundos a que converja y verás que pc1 y pc2 ya se hacen ping.

El problema: la rama de arriba (`r1–r2–r4`) es una **línea de backup cara** (por ejemplo, un enlace
4G/satélite medido por tráfico). Como todos los enlaces tienen el mismo coste por defecto, los dos
caminos empatan y OSPF instala ambos a la vez (**ECMP**, flag `+`), enviando tráfico también por
`r2`. Queremos que en condiciones normales **todo el tráfico vaya por `r3`**, manteniendo la rama
de `r2` viva en OSPF para que **si el camino por `r3` cae, el tráfico conmute automáticamente a
`r2`**.

**Objetivo:** ajustar los **costes OSPF** para que el tráfico entre las LANs de pc1 y pc2 vaya
**únicamente por `r3`** (en ambos sentidos), sin apagar ni filtrar el camino de backup por `r2`.

**Qué hay que conseguir, y qué se rechaza:**

- pc1 y pc2 se hacen ping en los dos sentidos.
- En `r1`, la ruta activa a la LAN de pc2 (`192.168.4.0/24`) es una ruta **OSPF** con gateway `r3`
  (`172.16.13.2`), y **no** tiene ninguna ruta activa por `r2` (`172.16.12.2`).
- En `r4`, la ruta activa a la LAN de pc1 (`192.168.1.0/24`) es una ruta **OSPF** con gateway `r3`
  (`172.16.34.1`), y **no** tiene ninguna ruta activa por `r2` (`172.16.24.1`).
- **No vale apagar ni filtrar el backup:** no se desactiva ninguna interfaz ni plantilla OSPF, no
  se rompe ninguna vecindad (todos los enlaces siguen en estado `Full`) y no se usan filtros de
  rutas (`/routing filter rule`).
- Todo sigue en una única instancia OSPF y el área backbone (`0.0.0.0`), **cero rutas estáticas** y
  **sin NAT** en los cuatro routers.

**Qué aprendes:**

- **Métrica (coste) en OSPF:** OSPF no cuenta saltos, suma el **coste** de cada enlace de salida a
  lo largo del camino y elige el de menor coste total.
- **ECMP (*Equal-Cost Multi-Path*):** cuando dos caminos suman exactamente el mismo coste, OSPF
  instala ambos como activos a la vez (flag `+`).
- **Coste de salida y asimetría:** el coste de una interfaz sólo cuenta para el tráfico que **sale**
  por ella. Si sólo ajustas un extremo (`r1`), la ida irá por `r3` pero la vuelta (`r4 → r1`)
  seguirá usando `r2`. Hay que ajustar ambos sentidos.
- **Failover automático sin tocar nada:** al penalizar el backup con coste en lugar de apagarlo,
  OSPF mantiene la vecindad y el mapa completo en su LSDB y conmuta solo a `r2` si cae `r3`.

Herramientas útiles: `/routing ospf interface-template print`, `/routing ospf interface print`,
`/routing ospf neighbor print`, `/ip route print`, `/routing route print detail where ospf`, `ping`
y `traceroute` en los PCs.

`lab console r1` · `lab console r2` · `lab console r3` · `lab console r4` · `lab console pc1` · `lab check` · `lab hint`

> Los PCs ya están bien configurados: el reto se resuelve en los routers, no los toques. No uses NAT.
