# El router de reserva

```
                          ┌── ether2 r1 192.168.1.2 ── ether3 ═══ inet
 pc1 192.168.1.10 ── sw ──┤                                       (Internet, 203.0.113.10)
   gw 192.168.1.1         └── ether2 r2 192.168.1.3 ── ether3 ═══ inet
```

La oficina ha comprado un **segundo router** (r2) con su propia salida a Internet, para que una
avería de r1 no deje a todo el mundo sin conexión. Los dos están en la LAN (r1 con `192.168.1.2`,
r2 con `192.168.1.3`) y los dos saben salir a Internet.

El problema: los PCs tienen configurada **una** puerta de enlace, `192.168.1.1`. Si fuera la IP de
r1 y r1 se estropeara, habría que ir PC por PC cambiándola a la de r2. Y ahora mismo ni siquiera
existe: nadie responde por `192.168.1.1`.

**Objetivo:** que `192.168.1.1` sea una **puerta de enlace virtual** que compartan r1 y r2 con
**VRRP**:

- **r1** es el router activo (maestro) mientras funcione.
- **r2** queda en reserva, preparado para quedarse con la puerta de enlace si r1 cae.
- `pc1` sale a Internet por `192.168.1.1` sin saber cuál de los dos le atiende.

**Qué aprendes:**

- Qué es una **puerta de enlace redundante** y el protocolo estándar para hacerla: **VRRP**
  (en Cisco, su equivalente propietario es HSRP).
- **Maestro y respaldo**, **prioridad** y **VRID**.
- La **IP y la MAC virtuales**: por qué los PCs no notan el cambio.
- Lo que VRRP **no** hace por ti (que el router de reserva tenga salida propia, por ejemplo).

Herramientas útiles: `/interface vrrp print` (flags `M` maestro, `B` respaldo), `/ip address print`;
en `pc1`, `ping 192.168.1.1`, `curl http://203.0.113.10/` e `ip neigh` (para ver la MAC de la puerta
de enlace).

Cuando lo tengas, **pruébalo**: apaga la LAN de r1 (`/interface ethernet set ether2 disabled=yes`) y
mira cómo r2 pasa a maestro y pc1 sigue navegando. Vuelve a encenderla antes de `lab check`.

`lab console r1` · `lab console r2` · `lab console sw` · `lab console pc1` · `lab check` · `lab hint`

> pc1, el switch y la salida a Internet ya están bien configurados: el reto se resuelve en r1 y r2.
