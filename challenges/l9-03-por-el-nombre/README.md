# Por el nombre

```
 pc1 192.168.1.10 ── ether2 ── r1 ── ether3 ── srv 192.168.20.10
 (oficina)            192.168.1.1   192.168.20.1   web.lab + apuestas.lab (misma IP)
```

La empresa comparte servidor con otra web, `apuestas.lab`, y Dirección no quiere que se entre a
ella desde la oficina. Lo malo: las dos webs están en la **misma IP y el mismo puerto**, y la intranet
`web.lab` tiene que seguir funcionando.

**Objetivo:** que desde pc1 no se pueda abrir `https://apuestas.lab` (ni `www.apuestas.lab`), ni
siquiera saltándose el DNS, sin tocar el acceso a `https://web.lab`. El filtro va en r1.

**Qué aprendes:**

- Qué viaja en claro en una conexión HTTPS: el **SNI** del ClientHello.
- A filtrar HTTPS por nombre con `tls-host` en RouterOS, y sus límites (ECH).
- Por qué bloquear por IP o por DNS no basta.

Herramientas útiles: `curl -v`, `curl --resolve`, `tcpdump -A`, `/ip firewall filter print stats`.

`lab console pc1` · `lab console r1` · `lab console srv` · `lab check` · `lab hint`
