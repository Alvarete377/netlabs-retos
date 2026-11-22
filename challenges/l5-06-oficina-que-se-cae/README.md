# La oficina que se cae

```
                         ┌═ ether3 ══ ether2 ┐
 pc1 (DHCP) ── ether2 ─ sw                    r1 ── ether4 ── 198.51.100.2 ┐
                         └═ ether4 ══ ether3 ┘   (principal)               ├── Internet (203.0.113.10)
                          sw ── ether5 ── ether2 ── r2 ── ether3 ── 198.51.100.6 ┘
                                                  (reserva)
 LAN 192.168.1.0/24 · r1 192.168.1.2 · r2 192.168.1.3 · puerta de enlace virtual 192.168.1.1
```

La oficina pagó por una red "que no se cae":

- **Dos cables** entre el switch y el router principal (`r1`), agrupados con **LACP**: si se corta
  uno, sigue el otro, y mientras tanto se usan los dos.
- Un **router de reserva** (`r2`) con **VRRP**: los PCs usan la puerta de enlace virtual
  `192.168.1.1`; normalmente la tiene `r1` y, si `r1` cae, la toma `r2`.
- `r1` reparte las direcciones por **DHCP**.

La realidad: la red va a ratos (unos días los PCs no consiguen dirección, otros sí), y ayer, cuando
se reinició `r1` para actualizarlo, **la oficina entera se quedó sin Internet** aunque `r2` estaba
encendido.

**Objetivo:**

- pc1 recibe dirección por DHCP y navega por Internet saliendo por `r1`.
- El switch y `r1` se unen con LACP (802.3ad), con los dos cables activos a la vez.
- `r1` es el router activo y `r2` el de reserva, con VRRP sobre `192.168.1.1`.
- Si cae `r1`, los PCs siguen saliendo por `r2` sin tocar nada.

> Es un reto difícil: hay **varios fallos** en tres tecnologías distintas, y alguno sólo se nota el
> día que algo se cae. Que funcione hoy no significa que esté bien.

**Qué aprendes:**

- Que una agregación de enlaces necesita el **mismo modo** en los dos extremos.
- Qué tiene que coincidir en VRRP para que dos routers formen grupo, y quién gana.
- Que la puerta de enlace que reparte el DHCP decide si la redundancia sirve de algo.
- A probar la redundancia **provocando la caída** (en el laboratorio: desactiva el bonding de `r1`).

Herramientas útiles: `/interface bonding monitor [find] once`, `/interface vrrp print detail`,
`/ip dhcp-server lease print`, `/ip dhcp-server network print`, y en pc1 `ip route` y
`curl http://203.0.113.10/` (te dice con qué IP sales).

`lab console sw` · `lab console r1` · `lab console r2` · `lab console pc1` · `lab check` · `lab hint`
