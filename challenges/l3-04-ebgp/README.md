# Hola, vecino de otro AS

```
 pc1 192.168.1.10/24                                         pc2 192.168.2.10/24
   gw 192.168.1.1                                              gw 192.168.2.1
        │                                                           │
     ether2                                                      ether3
       r1 ──ether3════════════════════════════════════════ether2── r2
            .1/30             172.16.12.0/30              .2/30

     AS 65001                                                  AS 65002
  (sin BGP aún)                                             (sin BGP aún)
```

Dos organizaciones independientes —cada una con su propio **Sistema Autónomo (AS)**— acaban de
interconectar sus routers de borde mediante el enlace `172.16.12.0/30`: **`r1`** pertenece al
**AS 65001** (con la LAN de `pc1`, `192.168.1.0/24`) y **`r2`** pertenece al **AS 65002** (con la
LAN de `pc2`, `192.168.2.0/24`). Todas las direcciones IP ya están puestas, pero no hay ninguna
ruta dinámica ni estática: `pc1` y `pc2` no se ven.

Dentro de una misma empresa se usa un protocolo interior como OSPF. Entre redes de organizaciones
distintas se usa **eBGP** (*External Border Gateway Protocol*), el protocolo que conecta Internet:
los routers no se descubren solos por multicast, sino que se configuran manualmente como vecinos
TCP y deciden explícitamente qué prefijos anunciar al otro AS.

**Objetivo:** establecer una sesión **eBGP** entre **`r1` (AS 65001)** y **`r2` (AS 65002)** sobre
el enlace `172.16.12.0/30`, anunciando cada router su propia LAN por BGP, para que `pc1` y `pc2` se
hagan ping en los dos sentidos.

**Qué hay que conseguir, y qué se rechaza:**

- `pc1` y `pc2` se hacen ping en los dos sentidos.
- Sesión **eBGP** establecida en ambos routers: `r1` como **AS 65001** con vecino `172.16.12.2`
  (**AS 65002**), y `r2` como **AS 65002** con vecino `172.16.12.1` (**AS 65001**). No vale iBGP
  (mismo AS) ni otros números de AS.
- `r1` aprende `192.168.2.0/24` como ruta **BGP activa** con `AS-PATH` `65002`, y `r2` aprende
  `192.168.1.0/24` como ruta **BGP activa** con `AS-PATH` `65001`.
- **Cero rutas estáticas** y **sin NAT** en los dos routers.

**Qué aprendes:**

- Qué es un **Sistema Autónomo (AS)** y por qué el enrutamiento entre organizaciones usa **BGP** en
  lugar de un IGP como OSPF.
- La diferencia entre **eBGP** (entre AS distintos: antepone el AS en el *AS-PATH*, distancia 20) e
  **iBGP** (dentro del mismo AS: no modifica el *AS-PATH*, distancia 200).
- **Por qué BGP no descubre vecinos solo:** corre sobre **TCP/179** entre pares declarados a mano
  (`remote.address`, `remote.as`) por control administrativo y seguridad entre redes ajenas.
- Cómo anunciar redes en RouterOS 7 mediante **`/ip firewall address-list`** y **`output.network`**
  en `/routing bgp connection`.

Herramientas útiles: `/routing bgp connection print`, `/routing bgp session print`,
`/routing bgp advertisements print`, `/ip route print` (las rutas BGP llevan la flag `b`),
`/routing route print detail where bgp`, `ping` y `traceroute` en los PCs.

`lab console r1` · `lab console r2` · `lab console pc1` · `lab console pc2` · `lab check` · `lab hint`

> Los PCs ya están bien configurados: el reto se resuelve en los routers, no los toques. No uses NAT.
