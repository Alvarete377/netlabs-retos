# Corre la voz

```
 pc1 192.168.1.10/24                                                   pc2 192.168.3.10/24
   gw 192.168.1.1                                                        gw 192.168.3.1
        │                                                                      │
     ether2                                                                 ether3
       r1 ──ether3════════════════ether2── r2 ──ether3════════════════ether2── r3
            .1/30  172.16.12.0/30  .2/30        .1/30  172.16.23.0/30  .2/30
```

Tres routers en cadena con todas las IPs puestas y **ni una ruta**: cada router sólo conoce sus
redes conectadas, así que pc1 y pc2 no se ven.

La empresa tiene equipos antiguos que sólo entienden **RIP**, el abuelo de los protocolos de
enrutamiento dinámico. Toca usarlo: que cada router le cuente a sus vecinos qué redes conoce, y
que los vecinos lo vayan contando a los suyos, como un rumor que **corre de boca en boca**.

**Objetivo:** activar RIP en los tres routers para que pc1 y pc2 se hagan ping en los dos sentidos.

**Qué hay que conseguir, y qué se rechaza:**

- r1 debe aprender la LAN de pc2 (`192.168.3.0/24`) **por RIP**, r3 la de pc1 (`192.168.1.0/24`) y
  r2 las dos.
- **Cero rutas estáticas**, y nada de OSPF ni BGP: todas las rutas remotas las pone RIP.
- **Sin NAT** en ningún router.

**Qué aprendes:**

- Qué es un protocolo **vector-distancia**: cada router sólo sabe lo que le cuentan sus vecinos
  ("la red X está a N saltos por aquí"), sin mapa completo de la red (al contrario que OSPF).
- La métrica de RIP: **saltos**, con un máximo de **15** (16 = inalcanzable).
- Las piezas de RIP en RouterOS 7: **instancia** (con qué rutas anuncia: `redistribute`) e
  **interface-template** (por qué interfaces habla RIP).
- Por qué RIP es lento (anuncios cada 30 s) y por qué hoy se prefiere OSPF.

Herramientas útiles: `/routing rip instance print`, `/routing rip neighbor print`,
`/ip route print` (las rutas de RIP llevan la flag `r`), `ping` y `traceroute` en los PCs.

`lab console r1` · `lab console r2` · `lab console r3` · `lab console pc1` · `lab check` · `lab hint`

> Los PCs ya están bien configurados: el reto se resuelve en los routers, no los toques. No uses NAT.
