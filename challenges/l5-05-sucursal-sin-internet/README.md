# La sucursal sin Internet

```
 pc1 (DHCP) ── ether2 ┐
                      ├ bridge "lan" 192.168.1.1/24 ── r1 ── ether4 ═══ ether2 ── isp ── ether3 ── srv 203.0.113.10
 pc2 (DHCP) ── ether3 ┘                                    (PPPoE)        servidor PPPoE           (web de Internet)
```

Abren una **sucursal** nueva. Un instalador dejó el router configurado "igual que en la central" y
se fue. Hoy llega la gente y **nadie tiene Internet**.

Lo que sabes:

- El proveedor da el acceso por **PPPoE**. Datos de la sucursal: usuario **`sucursal`**, contraseña
  **`Fibra2026`**.
- Los PCs se configuran solos por **DHCP** (el router es su servidor DHCP y DNS, con puerta de enlace
  `192.168.1.1`).
- La sucursal sale a Internet con la IP que le asigna el proveedor (NAT).

**Objetivo:** que la sucursal se conecte al proveedor y que los PCs naveguen por Internet **sin tocar
nada en ellos**. El router del proveedor no se toca.

**Qué aprendes:**

- A diagnosticar **por capas y por tramos**: sesión con el proveedor → ruta → NAT → configuración de
  los PCs.
- A usar el **registro** del router (`/log print`) para saber por qué no sube una conexión.
- Que un servicio "que funciona" (el DHCP reparte IPs) puede estar entregando datos equivocados.

Herramientas útiles: `/interface pppoe-client monitor pppoe-out1 once`, `/log print`,
`/ip route print`, `/ip firewall nat print stats`, `/ip dhcp-server lease print`,
`/ip dhcp-server network print`, `/ping`; en los PCs, `ip addr`, `ip route`, `ping` y `curl`.

`lab console r1` · `lab console pc1` · `lab console pc2` · `lab console isp` · `lab check` · `lab hint`

> No toques los PCs (piden su configuración por DHCP y la renuevan cada 30 segundos) ni el router del
> proveedor. El reto se resuelve en r1.
