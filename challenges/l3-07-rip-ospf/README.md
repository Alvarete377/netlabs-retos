# Dos idiomas, una red

```
   SEDE VIEJA (sólo RIP)              FRONTERA               SEDE NUEVA (sólo OSPF)

 pc1 192.168.1.10/24                                                   pc2 192.168.3.10/24
   gw 192.168.1.1                                                        gw 192.168.3.1
        │                                                                      │
     ether2                                                                 ether3
       r1 ──ether3════════════════ether2── r2 ──ether3════════════════ether2── r3
            .1/30  172.16.12.0/30  .2/30        .1/30  172.16.23.0/30  .2/30
           └──────────── RIP ─────────────┘   └──────────── OSPF ────────────┘
```

La empresa está migrando de RIP a OSPF. La sede nueva (r3) ya habla OSPF, pero la vieja (r1) tiene
equipos que sólo entienden RIP y todavía no se pueden cambiar. En medio está **r2**, que habla
los dos: RIP con r1 y OSPF con r3. Los dos protocolos funcionan (r2 tiene a r1 como vecino RIP y a
r3 como vecino OSPF en `Full`), y aun así pc1 y pc2 no se ven.

**Objetivo:** que pc1 y pc2 se hagan ping en los dos sentidos **sin cambiar de idioma a nadie**:
r1 sigue sólo con RIP, r3 sólo con OSPF. El arreglo va en r2.

**Qué hay que conseguir, y qué se rechaza:**

- r1 debe aprender la LAN de pc2 (`192.168.3.0/24`) **por RIP**, y r3 la de pc1 (`192.168.1.0/24`)
  **por OSPF**.
- r1 sigue **sin OSPF** y r3 **sin RIP**; r2 mantiene sus vecinos en los dos protocolos.
- **Cero rutas estáticas**, sin BGP y **sin NAT** en ningún router.

**Qué aprendes:**

- Por qué un protocolo de enrutamiento **no anuncia por sí solo** lo que ha aprendido otro.
- Qué es la **redistribución** y por qué hay que hacerla **en los dos sentidos**.
- Cómo se ven en OSPF las rutas que vienen de fuera: **rutas externas** (LSA tipo 5).
- Los riesgos de redistribuir en más de un punto (bucles).

Herramientas útiles: `/ip route print` en cada router, `/routing rip neighbor print`,
`/routing ospf neighbor print`, `/routing ospf lsa print`, `ping` y `traceroute` en los PCs.

`lab console r1` · `lab console r2` · `lab console r3` · `lab console pc1` · `lab check` · `lab hint`

> Los PCs ya están bien configurados: el reto se resuelve en los routers, no los toques. No uses NAT.
