# Un túnel entre sedes

```
 pc1 192.168.1.10                                                              pc2 192.168.2.10
   gw 192.168.1.1                                                                gw 192.168.2.1
        │                                                                              │
     ether2 ── r1 ── ether3 ═══════ ether2 ── isp ── ether3 ═══════ ether2 ── r2 ── ether3
  192.168.1.1   198.51.100.2/30   198.51.100.1      203.0.113.1    203.0.113.2/30   192.168.2.1
   (sede 1)       IP pública        ("Internet")                    IP pública        (sede 2)
```

La empresa tiene **dos sedes**. Cada una tiene su LAN privada y su router con IP pública, y las dos
salen a Internet sin problema. Pero los de la sede 1 no ven nada de la sede 2: `192.168.2.10` es una
dirección privada, y en Internet nadie sabe dónde está. El proveedor (`isp`) no va a enrutar redes
privadas (ni debe).

**Objetivo:** unir las dos LANs con un **túnel GRE** entre las IPs públicas de r1 y r2, de modo que
pc1 y pc2 se hagan ping en los dos sentidos. El proveedor no se toca.

**Qué aprendes:**

- Qué es un **túnel**: meter los paquetes entre LANs dentro de otros paquetes entre IPs públicas.
- Las tres piezas de cualquier túnel: la **interfaz**, la **red del túnel** y las **rutas** a la LAN
  remota.
- Que un túnel GRE **no cifra**: une redes, pero no es una VPN segura (los siguientes retos sí).

Herramientas útiles: `/interface gre print`, `/ip route print`, `/ping`, `/tool traceroute`; en los
PCs, `ping` y `traceroute` (verás que el túnel cuenta como un solo salto).

`lab console r1` · `lab console r2` · `lab console isp` · `lab console pc1` · `lab console pc2` · `lab check` · `lab hint`

> Los PCs y la salida a Internet ya están bien configurados. No toques el router del proveedor.
