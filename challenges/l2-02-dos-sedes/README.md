# Dos sedes

```
 pc1 192.168.1.10/24                                        pc2 192.168.2.10/24
   gw 192.168.1.1                                             gw 192.168.2.1
        │                                                          │
     ether2                                                     ether3
       r1 ──ether3── 172.16.12.1/30 ═══ 172.16.12.2/30 ──ether2── r2
```

Una empresa tiene dos sedes, cada una con su router y su LAN, unidas por un enlace punto a punto
`172.16.12.0/30`. Todas las direcciones IP ya están puestas, pero pc1 y pc2 no se ven: **r1 solo
conoce las redes que tiene conectadas** (`192.168.1.0/24` y `172.16.12.0/30`) y no sabe nada de la
LAN de pc2; a r2 le pasa lo mismo con la de pc1.

**Objetivo:** que pc1 y pc2 se hagan ping, añadiendo **rutas estáticas específicas** en r1 y r2
(una por router, hacia la LAN de la otra sede). No vale una ruta por defecto ni NAT; tampoco vale
un bloque más amplio (p. ej. 192.168.0.0/16) y el gateway de cada ruta debe ser la IP del otro router
en el enlace 172.16.12.0/30.

**Qué aprendes:**

- Una **ruta estática** dice: "para llegar a esta red (`dst-address`), manda los paquetes a este
  router vecino (`gateway`, el *next-hop*)". El next-hop debe ser una IP alcanzable directamente.
- El tráfico necesita **ida y vuelta**: aunque r1 sepa llegar a la LAN de pc2, la respuesta solo
  vuelve si r2 sabe llegar a la LAN de pc1. Hay que configurar los dos routers.
- Enrutar no es enmascarar: los paquetes viajan con sus direcciones originales (sin NAT).

Herramientas útiles: `/ip route print`, `/ip route add`, `ping` y `traceroute` en los PCs.

`lab console r1` · `lab console r2` · `lab console pc1` · `lab check` · `lab hint`

> Los PCs y las IPs de los routers ya están bien: el reto se resuelve con rutas. No uses NAT.
