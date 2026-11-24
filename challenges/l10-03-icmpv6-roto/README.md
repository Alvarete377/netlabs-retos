# El ICMP que no debías tirar

```
 pc1 2001:db8:1::10 ── ether2 ── r1 ── ether3 ── srv 2001:db8:20::10 (web, puerto 80)
 (oficina)                                         (servidores)
```

El becario "endureció" el firewall IPv6 de r1 siguiendo una guía antigua de IPv4. Desde entonces,
la oficina no llega a nada: ni a la web de srv, ni a hacer ping. Lo raro: pc1 tiene su dirección
IPv6 perfectamente.

**Objetivo:**

1. Que pc1 vuelva a abrir `http://[2001:db8:20::10]/` y a hacerle ping.
2. Sin abrir de más: desde la red de servidores no se pueden abrir conexiones a la oficina ni al
   SSH de r1, y las cadenas siguen terminando en drop.

**Qué aprendes:**

- **Neighbor Discovery**: el "ARP" de IPv6 va dentro de ICMPv6.
- Qué ICMPv6 no se puede filtrar (RFC 4890) y por qué Packet Too Big es vital.
- A leer `ip -6 neigh` y los contadores del firewall.

`lab console r1` · `lab console pc1` · `lab console srv` · `lab check` · `lab hint`
