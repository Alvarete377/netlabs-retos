# Plan B

```
                                   fibra (principal)
 pc1 192.168.1.10/24      ether3 172.16.12.1/30 ═ 172.16.12.2/30 ether2 (CAÍDA)
   gw 192.168.1.1   ┌──────────────────────────────────────────────────── r2 ── ether4 192.168.99.1/24
        │           │                                                   ether3       │
     ether2 ─── r1 ─┤                                               172.16.23.1/30  srv 192.168.99.10
                    │                                                     ║
                    └──────────────────────────────────────────────────── r3
                          ether4 172.16.13.1/30 ═ 172.16.13.2/30 ether2  ether3 172.16.23.2/30
                                   4G (respaldo)
```

La sucursal (r1) tiene dos salidas hacia el centro de datos: una **fibra** (r2) y un router **4G** de
respaldo (r3), que llega al mismo sitio a través de la red del operador. Esta mañana la fibra ha caído
en el lado del operador: el cable sigue conectado en la sucursal, pero al otro lado no contesta nadie.
Resultado: **la sucursal entera está sin servicio**, aunque el 4G funciona perfectamente.

El operador ya está con la avería; tu trabajo es que la sucursal **no se vuelva a quedar tirada** cuando
caiga la fibra, y que vuelva a ella sola cuando se arregle.

**Objetivos:**

- pc1 llega al servidor `192.168.99.10` (y el servidor a pc1), con la fibra todavía caída.
- La fibra sigue siendo la salida preferida; el 4G sólo se usa mientras la fibra no responda.
- No toques r2 ni r3: son del operador (su configuración ya contempla el respaldo).
- Sin NAT en r1.

**Qué aprendes:** rutas estáticas **flotantes** (`distance`), por qué una ruta puede seguir «activa»
hacia un gateway muerto, y cómo `check-gateway` la retira y la devuelve sola.

Herramientas útiles: `/ip route print detail`, `/tool traceroute 192.168.99.10`, `/ping 172.16.12.2`,
`/interface print` y `ping` desde pc1.

`lab console r1` · `lab console pc1` · `lab check` · `lab hint`
