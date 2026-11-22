# Tu primer router

```
 pc1 192.168.1.10/24 ──ether2──┐
   gateway 192.168.1.1         r1
 pc2 192.168.2.10/24 ──ether3──┘
   gateway 192.168.2.1
```

Hasta ahora todo era capa 2: los equipos compartían subred y los switches solo reenviaban tramas.
Aquí pc1 y pc2 están en **redes distintas** (`192.168.1.0/24` y `192.168.2.0/24`) y entre ellas hay
un router, r1, que todavía no tiene ninguna dirección IP. Hasta que no la tenga, no se ven.

**Objetivo:** que pc1 y pc2 se hagan ping a través de r1, con r1 como **puerta de enlace**
(gateway) de cada LAN: `192.168.1.1` para pc1 y `192.168.2.1` para pc2.

**Qué aprendes:**

- Un PC solo habla directamente con los equipos de su propia red. Para cualquier otra red envía
  los paquetes a su **gateway**, que es la IP del router en esa LAN. Los PCs ya traen puesto su
  gateway: cada uno usa la `.1` de su LAN (192.168.1.1 y 192.168.2.1); puedes verlo con `ip route`
  en `lab console pc1`.
- Cuando le das una IP a una interfaz del router, r1 pasa a conocer esa red como
  **red conectada** y puede reenviar paquetes entre las redes que tiene conectadas. No hace
  falta ninguna ruta extra.
- Un router que no enmascara (sin NAT) deja las direcciones originales intactas.

Herramientas útiles: `/ip address print`, `/ip route print`, `ip route` y `ping` en los PCs.

`lab console r1` · `lab console pc1` · `lab check` · `lab hint`

> Los PCs ya están bien configurados: el reto se resuelve en el router, no los toques. No uses NAT.
