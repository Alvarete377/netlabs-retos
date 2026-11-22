# No hay vuelta

```
 pc1 192.168.1.10/24                                                         pc2 192.168.3.10/24
   gw 192.168.1.1                                                              gw 192.168.3.1
        │                                                                           │
     ether2                                                                      ether3
       r1 ──ether3── 172.16.12.1/30 ═ 172.16.12.2/30 ──ether2── r2 ──ether3── 172.16.23.1/30 ═ 172.16.23.2/30 ──ether2── r3
```

Tres routers en cadena: r1 (con pc1), r2 (el del medio) y r3 (con pc2). Las direcciones IP están
todas bien puestas. Alguien ha tocado las rutas y **pc1 y pc2 no se ven**. Hay varios fallos, y están
repartidos entre los routers.

**Objetivo:** que pc1 llegue a pc2 y pc2 a pc1 (en ambos sentidos).

**Cómo debería estar la red** (la configuración correcta, para que sepas a qué te enfrentas):

- r1 manda todo lo que no es suyo a r2 (`172.16.12.2`).
- r2 sabe llegar a `192.168.1.0/24` (por r1) y a `192.168.3.0/24` (por r3, `172.16.23.2`).
- r3 manda todo lo que no es suyo a r2 (`172.16.23.1`).

**Reglas generales:**

- **Sin NAT** en ningún router (enruta, no enmascares).
- Los PCs y las IPs de los routers ya están bien: el reto se resuelve con rutas.

**Qué aprendes:** seguir un paquete salto a salto (`ping`, `/tool traceroute`), leer las flags de
`/ip route print`, y recordar que la conectividad son **dos** caminos: ida y vuelta.

Herramientas útiles: `/ip route print`, `/ip route print detail`, `/tool traceroute` (se para con
Ctrl-C), `/ping`, y `tcpdump -ni eth1` en los PCs.

`lab console r1` · `lab console r2` · `lab console r3` · `lab check` · `lab hint`

> Los PCs y las IPs de los routers ya están bien: el reto se resuelve con rutas. No uses NAT.
