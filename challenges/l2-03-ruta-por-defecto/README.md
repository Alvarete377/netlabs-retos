# Todo hacia el núcleo

```
 pc1 192.168.1.10/24          sucursal                    núcleo            pc2 192.168.2.10/24
   gw 192.168.1.1                                                            gw 192.168.2.1
        │                                                                          │
     ether2                                                                     ether3
       r1 ──ether3── 172.16.12.1/30 ═══ 172.16.12.2/30 ──ether2── r2 ──ether4── srv 192.168.99.10/24
                                                                                  gw 192.168.99.1
```

Una sucursal (r1, con pc1) cuelga de la oficina central, el **núcleo** (r2), a través del enlace
`172.16.12.0/30`. En el núcleo hay otras dos redes: la LAN de pc2 (`192.168.2.0/24`) y la de un
servidor (`192.168.99.0/24`). Todas las IPs ya están puestas, pero no hay ninguna ruta: pc1 no
llega a nada que esté al otro lado del enlace.

**Objetivo:** que pc1 llegue a pc2 y al servidor, y que el servidor pueda responder a pc1.

**Qué hay que hacer, y qué se rechaza:**

- **r1 (sucursal): una única ruta estática, la ruta por defecto** (`0.0.0.0/0`), con gateway la IP de
  r2 en el enlace (`172.16.12.2`). No se aceptan rutas específicas en r1 (ni una por red, ni
  rutas extra junto a la por defecto): la sucursal no tiene por qué conocer cada red del núcleo.
- **r2 (núcleo): una ruta específica de vuelta** a la LAN de la sucursal (`192.168.1.0/24`), con
  gateway la IP de r1 en el enlace (`172.16.12.1`). No se acepta una ruta por defecto en r2: el
  núcleo conoce las redes de la empresa una a una y no manda "todo lo demás" hacia una sucursal.
- **Sin NAT** en ningún router. Un masquerade en r1 haría que r2 respondiera sin necesitar ruta de
  vuelta y escondería justo lo que este reto quiere que descubras.
- Las rutas deben estar activas (no `disabled`).

**Qué aprendes:**

- Una **ruta por defecto** (`0.0.0.0/0`) es el "para todo lo que no conozco, mándalo por aquí".
  Es lo normal en una sucursal o en un extremo de la red: un solo camino hacia el resto.
- Una ruta por defecto **no resuelve la vuelta**: el núcleo sí necesita saber volver a la sucursal.
  Los paquetes de respuesta (srv → pc1) también se enrutan por la tabla de r2.
- Cuando varias rutas encajan con un destino, gana la **más específica** (el prefijo más largo).

Herramientas útiles: `/ip route print`, `/ip route add`, `ping` y `traceroute` en los PCs.

`lab console r1` · `lab console r2` · `lab console pc1` · `lab check` · `lab hint`

> Los PCs y las IPs de los routers ya están bien: el reto se resuelve con rutas. No uses NAT.
