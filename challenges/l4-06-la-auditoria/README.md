# La auditoría

```
 pc1 192.168.1.10 ── ether2 ┐
   (empleados)              ├── lan ── r1 ── ether4 ── inet 203.0.113.10
 web 192.168.1.20 ─ ether3 ┘  192.168.1.1   203.0.113.1    ("Internet", con su propia web)
   (web 80, SSH 22)                      (IP pública)
```

La oficina tiene una web interna (`web`) que debe verse en Internet en **http://203.0.113.1**.
Un técnico montó el firewall de `r1` el viernes. El lunes:

- Los clientes llaman: **la web no carga** desde Internet.
- Los empleados dicen que, abran la web que abran, **les sale la de la oficina** (o nada).
- Y la **auditoría de seguridad** externa ha encontrado que el router se puede administrar desde
  Internet.

**Objetivo:**

- Desde Internet, `http://203.0.113.1` abre la web de la oficina, y el servidor ve la **IP real**
  del visitante.
- Desde la LAN, la web funciona **también por la dirección pública** (y por la interna).
- Los empleados navegan por Internet con la IP pública de la oficina.
- La gestión del router (SSH y Winbox) sólo desde la LAN.
- Desde Internet no se llega a nada más de la LAN. Los filtros `input` y `forward` siguen
  terminando en `drop`.

> Es un reto difícil: hay **varios fallos** y unos tapan a otros. Arreglar uno de la forma "obvia"
> puede dejar otro escondido.

**Qué aprendes:**

- A acotar bien un `dstnat` (por IP pública, no por interfaz) y lo que pasa si no.
- El orden de las reglas cuando conviven NAT y filtro.
- El **hairpin NAT**: entrar a un servidor interno por la IP pública desde la propia LAN.
- A auditar la cadena `input`: qué servicios del router quedan expuestos.

Herramientas útiles: `/ip firewall nat print stats`, `/ip firewall filter print stats`,
`/ip firewall connection print`, y desde los PCs `curl http://...` y `nc -zv <ip> <puerto>`.

`lab console r1` · `lab console pc1` · `lab console web` · `lab console inet` · `lab check` · `lab hint`
