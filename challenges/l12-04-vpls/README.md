# El cable más largo del mundo

```
 pc1 10.10.10.1 ── ether3 ── pe1 ── p ── pe2 ── ether3 ── pc2 10.10.10.2
 (cliente, sede 1)           (núcleo MPLS)              (cliente, sede 2)
```

Un cliente tiene una aplicación antigua que sólo funciona si los equipos están en **la misma red
local** (usa broadcast). Sus sedes están en dos ciudades. Quiere que el operador las una "con un
cable", sin routers en medio: misma subred `10.10.10.0/24` y sin puerta de enlace.

El núcleo MPLS (OSPF + LDP) ya funciona.

**Objetivo:** unir las dos sedes en el mismo segmento Ethernet con **VPLS**, sin poner IPs del
cliente en los PE.

**Qué aprendes:**

- Servicios de nivel 2 sobre MPLS: *pseudowires* y VPLS.
- LDP dirigido entre PE.
- La diferencia práctica entre una VPN de nivel 2 y una de nivel 3.

`lab console pe1` · `lab console pe2` · `lab console pc1` · `lab check` · `lab hint`
