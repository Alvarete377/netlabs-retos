# Todos a Internet

```
 pc1 192.168.1.10/24            198.51.100.2/30   198.51.100.1/30          srv 203.0.113.10
   gw 192.168.1.1                (IP pública)       (proveedor)            (web de Internet)
        │                              │                 │                        │
     ether2 ─────── r1 ─────────── ether3 ═════════ ether2 ── isp ── ether3 ──────┘
   192.168.1.1/24                                              203.0.113.1/24
     red privada                                  Internet
```

La oficina por fin tiene Internet: el proveedor (`isp`) le ha dado una **IP pública**,
`198.51.100.2`, y r1 ya tiene la ruta por defecto hacia él. Pero desde `pc1` no carga ni una web.

El técnico del proveedor es tajante: "nosotros no enrutamos redes privadas; si te llega tráfico de
`192.168.1.x` a nuestra red, lo tiramos". Y tiene razón: las direcciones `192.168.x.x` (como
`10.x.x.x` y `172.16–31.x.x`) son **privadas** y en Internet nadie sabe volver a ellas.

**Objetivo:** que `pc1` navegue por la web del servidor de Internet (`http://203.0.113.10/`) y que
el servidor **vea llegar la conexión desde la IP pública de la oficina**, no desde la privada de
`pc1`. El router del proveedor no se toca.

**Qué aprendes:**

- Por qué existen las **redes privadas** y por qué no se pueden enrutar en Internet.
- **NAT de origen** (`srcnat`): cambiar la IP de origen de lo que sale, y deshacerlo en las
  respuestas.
- La diferencia entre **masquerade** y **src-nat** con una dirección fija.
- Cómo el **seguimiento de conexiones** permite que las respuestas vuelvan al PC correcto.

Herramientas útiles: en `pc1`, `curl http://203.0.113.10/` (el servidor te dice desde qué IP te
ve) y `ping`; en r1, `/ip firewall nat print stats` y `/ip firewall connection print`; en `isp`,
`/ip route print`.

`lab console r1` · `lab console isp` · `lab console pc1` · `lab console srv` · `lab check` · `lab hint`

> Los PCs y el servidor ya están bien configurados: el reto se resuelve en r1. No toques el router
> del proveedor.
