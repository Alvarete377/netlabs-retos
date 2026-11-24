# Contraseñas en claro

```
 pc1 192.168.1.10 ─── ether2 ┐
 (contabilidad)              │
 analista 192.168.1.50 ─ ether3 ┤ sw ── ether4 ── ether2 ── r1 ── ether3 ── srv 192.168.20.10
 (tú)                        ┘                   192.168.1.1   192.168.20.1   (servidor contable)
```

Auditoría de seguridad. La aplicación de contabilidad de pc1 es muy antigua y entra cada pocos
segundos en el servidor contable con su usuario y contraseña. Se sospecha que lo hace por **telnet**,
que no cifra nada. Para demostrarlo, el técnico ha puesto el switch `sw` en "modo espejo": sus
puertos **no aprenden direcciones**, así que repite cada trama por todos los puertos y desde el PC
`analista` puedes ver el tráfico de los demás.

**Objetivo:**

1. Desde `analista`, captura el tráfico y averigua el **usuario** y la **contraseña** con los que
   entra la aplicación. Respóndelos con `lab answer`.
2. Corta en r1 el acceso por **telnet** (TCP 23) hacia los servidores. El **SSH** (22) debe seguir
   funcionando.
3. Terminada la auditoría, quita el modo espejo: el switch vuelve a aprender direcciones.

Este reto tiene **preguntas**: respóndelas con `lab answer` (cuentan para `lab check`).

**Qué aprendes:**

- A capturar con `tcpdump` y a leer el contenido de los paquetes (`-A`).
- Por qué un PC normalmente **no** ve el tráfico de los demás, y qué cambia con un puerto espejo.
- Por qué telnet, FTP o HTTP sin cifrar no se deben usar.

Herramientas útiles: en analista, `tcpdump -i eth1 -nn` (con filtros como `port 23` y `-A`); en sw y
r1, `/interface bridge port print detail`, `/tool torch` y `/tool sniffer quick`.

> Capturar tráfico ajeno sólo es legítimo en redes propias o con autorización, como aquí.

`lab console analista` · `lab console sw` · `lab console r1` · `lab answer` · `lab check` · `lab hint`
