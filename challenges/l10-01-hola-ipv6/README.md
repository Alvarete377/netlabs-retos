# Hola, IPv6

```
 pc1 ──── ether2 ── r1 ── ether3 ──── pc2
 2001:db8:1::/64            2001:db8:2::/64
```

Toca estrenar IPv6. r1 une dos LANs y los PCs no tienen IPv4: sólo IPv6, y sin configurar.

**Objetivo:**

1. Da a r1 la dirección `::1` en cada LAN: `2001:db8:1::/64` (pc1) y `2001:db8:2::/64` (pc2).
2. Haz que los PCs **se configuren solos** (sin tocarlos).
3. Que pc1 y pc2 se hagan ping.

**Qué aprendes:**

- Cómo se escribe una dirección IPv6 y qué es un /64.
- **SLAAC**: anuncios de router (RA) y autoconfiguración.
- Las direcciones **link-local** (`fe80::`) y por qué la puerta de enlace es una de ellas.

Herramientas útiles: `ip -6 addr`, `ip -6 route`, `ping`; en r1 `/ipv6 address print`, `/ipv6 nd print`.

`lab console r1` · `lab console pc1` · `lab check` · `lab hint`
