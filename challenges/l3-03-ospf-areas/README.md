# Divide y vencerás

```
 pc1 192.168.1.10/24                                                   pc2 192.168.3.10/24
   gw 192.168.1.1                                                        gw 192.168.3.1
        │                                                                      │
     ether2                                                                 ether3
       r1 ──ether3════════════════ether2── r2 ──ether3════════════════ether2── r3
            .1/30  172.16.12.0/30  .2/30        .1/30  172.16.23.0/30  .2/30

       ├────── área backbone (0.0.0.0) ────┤├──────── área 1 (0.0.0.1) ────────┤
                                          ABR
                                     (ya en 0.0.0.0)               (sin OSPF aún)
```

Tres routers en cadena con todas las IPs puestas. La red ha crecido y ya no queremos meter todas
las sucursales en el área backbone (`0.0.0.0`): el núcleo (`r1` y el enlace `r1–r2`) ya habla OSPF
en el **área backbone**, pero la nueva sucursal (`r3` y el enlace `r2–r3`) debe vivir en un área
propia, el **área 1 (`0.0.0.1`)**, con **`r2` haciendo de ABR** (*Area Border Router*) entre ambas.

Ahora mismo `r1` y `r2` ya son vecinos OSPF en el backbone, pero `r2` todavía no tiene el área 1 y
`r3` no tiene OSPF configurado: pc1 y pc2 no se ven.

**Objetivo:** crear el **área 1 (`area-id=0.0.0.1`)** en `r2` (dentro de su misma instancia OSPF) y
en `r3`, cubriendo el enlace `r2–r3` (`172.16.23.0/30`) y la LAN de pc2 (`192.168.3.0/24`), para
que `r2` actúe como ABR y pc1 y pc2 se hagan ping en los dos sentidos.

**Qué hay que conseguir, y qué se rechaza:**

- pc1 y pc2 se hacen ping en los dos sentidos.
- `r1` sigue únicamente en el área backbone (`0.0.0.0`).
- `r2` ejecuta una **única instancia OSPF** con el área backbone (`0.0.0.0`) y el área 1 (`0.0.0.1`)
  activas, y tiene vecinos en estado `Full` en **ambas áreas** (`r1` en backbone y `r3` en área 1).
- `r3` habla OSPF **únicamente en el área 1 (`0.0.0.1`)** — **no** en backbone — con el enlace
  `r2–r3` (`172.16.23.0/30`) y la LAN de pc2 (`192.168.3.0/24`) activos en OSPF.
- `r1` aprende la LAN de pc2 (`192.168.3.0/24`) como **ruta OSPF inter-área** (mediante un LSA tipo
  3 `inter-area-prefix`), y `r3` aprende la LAN de pc1 (`192.168.1.0/24`) como **ruta OSPF
  inter-área**. No vale meterlo todo en backbone ni usar redistribución (`redistribute=connected` u
  otra instancia OSPF).
- **Cero rutas estáticas** y **sin NAT** en los tres routers.

> **Nota sobre RouterOS 7.16:** si añades el área 1 en `r2` **antes** de que `r3` hable OSPF (el área
> se queda un rato sin vecinos), RouterOS 7.16 no vuelve a anunciar en el backbone que `r2` es ABR
> (bit `bits=B` de su *Router LSA*) cuando `r3` aparece después. Si configuras `r3` primero, no pasa.
> Si tras configurar el área 1 ves que `r2`
> tiene dos vecinos `Full` y `r3` ya aprende `192.168.1.0/24`, pero `r1` aún no instala
> `192.168.3.0/24`, reinicia la instancia OSPF en `r2` (`/routing ospf instance disable default` y
> después `enable default`).

**Qué aprendes:**

- **Por qué OSPF divide la red en áreas:** limitar el tamaño de la base de datos de enlaces (LSDB)
  y contener los recálculos SPF dentro de cada área. Todas las áreas se conectan a través del
  **backbone (`0.0.0.0`)**.
- Qué es un **ABR (*Area Border Router*):** un router con interfaces en más de un área dentro de la
  misma instancia OSPF; mantiene una LSDB separada por área y traduce las redes de un área a otra
  mediante anuncios resumidos.
- **LSAs tipo 1, 2 y 3:** *Router LSA* (`type="router"`), *Network LSA* (`type="network"`) — ambos
  confinados a su propia área — y *Summary LSA* (`type="inter-area-prefix"`), generados por el ABR
  para anunciar prefijos de un área en otra.
- Cómo distinguir rutas **intra-área** (`ospf.type=intra`) de rutas **inter-área**
  (`ospf.type=inter`) en RouterOS 7.

Herramientas útiles: `/routing ospf area print`, `/routing ospf interface print`,
`/routing ospf neighbor print`, `/routing ospf lsa print`, `/routing route print detail where ospf`,
`/ip route print`, `ping` y `traceroute` en los PCs.

`lab console r1` · `lab console r2` · `lab console r3` · `lab console pc1` · `lab check` · `lab hint`

> Los PCs ya están bien configurados: el reto se resuelve en los routers, no los toques. No uses NAT.
