# Lunes negro en la sede

```
 pc1 ── ether2 ── r1 ── ether3 ────── ether2 ── r2 ── ether3 ── srv 192.168.20.10
 192.168.1.0/24       172.16.12.0/30 (r1 .1, r2 .2)     192.168.20.0/24
 (sede)                                (centro de datos)
```

Lunes, 8:00. Durante el fin de semana "alguien" migró el DHCP y el DNS de la sede al centro de
datos, y ahora los PCs de la sede no consiguen IP. Los que la tenían de antes tampoco abren la
intranet por su nombre.

Diseño previsto: r2 reparte las direcciones de la sede (pool `sede1`) a través del **relay** de r1;
r1 es el DNS de la sede y reenvía lo que no sabe al DNS de la empresa en r2. El firewall de r2 sólo
deja entrar desde las sedes lo imprescindible.

**Objetivo:**

1. pc1 recibe IP del DHCP central, con r1 como puerta de enlace y como DNS.
2. pc1 resuelve y abre `http://intranet.empresa.lab/`.
3. Sin abrir de más: r2 sigue terminando su input en drop y la sede no llega a su SSH.

**Qué aprendes:**

- Diagnosticar un DHCP con relay de punta a punta: relay, firewall, servidor.
- Separar dos problemas que parecen uno (direcciones y nombres).
- `/tool sniffer`, contadores del firewall y `dig` para encontrar dónde se corta.

`lab console pc1` · `lab console r1` · `lab console r2` · `lab check` · `lab hint`
