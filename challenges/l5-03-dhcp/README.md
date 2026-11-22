# Reparto automático

```
 pc1 (sin IP) ── ether2 ┐
                        ├ bridge "lan" 192.168.1.1/24 ── r1 ── ether4 203.0.113.1/24 ── inet 203.0.113.10
 pc2 (sin IP) ── ether3 ┘                                                                 (web de Internet)
```

Han llegado dos portátiles nuevos y los han conectado a la red. No tienen IP: están pidiendo una
por **DHCP** una y otra vez, pero en la oficina nadie la reparte. Configurar a mano cada equipo no
escala (y cuando el próximo becario cambie un cable, alguien repetirá una IP).

r1 ya tiene la LAN montada (bridge `lan` con `ether2` y `ether3`) y la salida a Internet con NAT.

**Objetivo:** que r1 sea el **servidor DHCP** de la oficina y entregue a cada equipo:

| Dato | Valor |
|---|---|
| Dirección | del rango `192.168.1.100` – `192.168.1.199` |
| Máscara | `/24` |
| Puerta de enlace | `192.168.1.1` (r1) |
| DNS | `192.168.1.1` (r1, que reenvía las consultas) |

Con eso, los PCs tienen que salir a Internet **sin tocar nada en ellos**.

**Qué aprendes:**

- Cómo funciona **DHCP**: *Discover, Offer, Request, Ack* (DORA).
- Las tres piezas en RouterOS: **pool**, **servidor** y **red** (opciones que se entregan).
- Por qué el servidor va sobre el **bridge** y no sobre sus puertos.
- Qué son las **concesiones** (*leases*) y cómo reservar una IP fija a un equipo.

Herramientas útiles: `/ip dhcp-server print`, `/ip dhcp-server lease print`, `/ip pool print`; en
los PCs, `ip addr`, `ip route` y `cat /etc/resolv.conf`.

`lab console r1` · `lab console pc1` · `lab console pc2` · `lab console inet` · `lab check` · `lab hint`

> No toques los PCs: están pidiendo dirección solos. El reto se resuelve en r1.
