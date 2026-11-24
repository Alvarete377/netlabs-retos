# Dos sedes, cero NAT

```
 pc1 ── ether3 ── r1 ── ether2 ─────── ether2 ── r2 ── ether3 ── pc2
 2001:db8:1::/64        2001:db8:12::/64 (r1 ::1, r2 ::2)      2001:db8:2::/64
```

Las dos sedes ya tienen IPv6: los PCs se configuran solos y cada router conoce su LAN y el enlace
entre ellos. Pero pc1 no llega a pc2.

**Objetivo:** que pc1 y pc2 se hagan ping, con **rutas estáticas IPv6** en r1 y r2.

**Qué aprendes:**

- `/ipv6 route` en RouterOS: igual que en IPv4, con prefijos más largos.
- Puerta de enlace global frente a **link-local** (`fe80::...%interfaz`).
- Por qué IPv6 no necesita NAT entre sedes.

`lab console r1` · `lab console r2` · `lab console pc1` · `lab check` · `lab hint`
