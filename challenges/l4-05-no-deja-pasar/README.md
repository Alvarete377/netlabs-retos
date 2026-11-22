# El firewall que no deja pasar

```
 pc1 192.168.1.10 ── ether2 ┐                 ┌ ether4 ── inet 203.0.113.10
   (LAN, empleados)         ├────── r1 ───────┤            ("Internet")
 srv 198.51.100.10 ─ ether3 ┘
   (DMZ: web 80, SSH 22, MySQL 3306)
```

La misma empresa del reto "Lo justo y necesario", la misma política aprobada:

| Desde ↓ / hacia → | LAN | DMZ | Internet |
|---|---|---|---|
| **LAN** | — | todo | todo |
| **DMZ** | nada (no puede iniciar conexiones) | — | todo |
| **Internet** | nada | sólo la web (TCP 80) | — |

Esta vez el firewall lo montó otro técnico, que se fue de vacaciones dejando una nota: "está todo,
cada regla tiene su comentario". El lunes:

- Los clientes llaman: **la web no carga** desde Internet.
- Los empleados **no pueden navegar**.
- El servidor de la DMZ **no descarga actualizaciones**.
- Y la auditoría de seguridad ha encontrado que **desde el servidor de la DMZ se llega a los PCs de
  la LAN**.

**Objetivo:** dejar el firewall cumpliendo la política, con la LAN saliendo a Internet con la IP
pública de la empresa. El router en sí ya está protegido (cadena `input`): no toques esas reglas.

**Qué aprendes:**

- A **leer un firewall como lo lee el router**: de arriba abajo, la primera regla que encaja decide.
- A usar los **contadores** (`print stats`) para saber qué regla se está llevando cada paquete.
- A no fiarte de los **comentarios**: lo que cuenta son las condiciones.
- Los errores más típicos de un firewall real.

Herramientas útiles: `/ip firewall filter print`, `/ip firewall filter print stats`,
`/ip firewall nat print`, `/ip firewall connection print`; en los PCs, `curl`, `nc -zv` y `ping`.

`lab console r1` · `lab console pc1` · `lab console srv` · `lab console inet` · `lab check` · `lab hint`

> Los equipos ya están bien configurados: el reto se resuelve en r1.
