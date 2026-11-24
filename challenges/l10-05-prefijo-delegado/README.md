# El prefijo que no llega

```
 srv 2001:db8:ff::10 ── ether3 ── isp ── ether2 ─────── ether2 ── r1 ── ether3 ── pc1
 (Internet, web :80)            (operador)   2001:db8:f::/64        (oficina)    LAN: ¿?
```

La oficina ha contratado IPv6. El operador (`isp`) no da redes fijas: **delega un prefijo por
DHCPv6** al router del cliente, y éste debe repartirlo en su LAN. El técnico que lo montó en r1 se
fue a media configuración: hay cliente DHCPv6, hay una dirección para la LAN, hay firewall... y pc1
sigue sin IPv6 global.

`isp` está bien (no lo toques). Todo se arregla en **r1**.

**Objetivo:**

1. Que r1 reciba un prefijo delegado del operador.
2. Que la LAN use un /64 de ese prefijo y pc1 se configure solo.
3. Que pc1 llegue a `http://[2001:db8:ff::10]/`.
4. Sin abrir el router a Internet.

**Qué aprendes:**

- **DHCPv6-PD**: cómo reciben IPv6 las casas y oficinas de verdad.
- Pools, `from-pool` y `advertise` en RouterOS.
- Por qué el firewall de input tiene que dejar pasar DHCPv6 (UDP 546).

`lab console r1` · `lab console isp` · `lab console pc1` · `lab check` · `lab hint`
