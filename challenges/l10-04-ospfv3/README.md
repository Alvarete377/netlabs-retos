# Rutas que viajan solas (v6)

```
 pc1 ── ether3 ── r1 ── ether2 ──── ether2 ── r2 ── ether3 ──── ether2 ── r3 ── ether3 ── pc3
 2001:db8:1::/64        2001:db8:12::/64                 2001:db8:23::/64          2001:db8:3::/64
```

Tres routers en fila con IPv6 ya configurado en cada interfaz. pc1 y pc3 se configuran solos, pero
nadie le ha contado a nadie dónde están las redes.

**Objetivo:** que los routers se cuenten las rutas IPv6 con **OSPFv3** y pc1 y pc3 se hagan ping,
sin rutas estáticas.

**Qué aprendes:**

- OSPFv3 en RouterOS 7 (`version=3`).
- Qué cambia frente a OSPFv2: vecinos por link-local, router-id de 32 bits.
- La trampa del router-id repetido.

`lab console r1` · `lab console r2` · `lab console r3` · `lab check` · `lab hint`
