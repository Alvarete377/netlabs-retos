# Lo justo y necesario

```
 pc1 192.168.1.10 ── ether2 ┐                 ┌ ether4 ── inet 203.0.113.10
   (LAN, empleados)         ├────── r1 ───────┤            ("Internet")
 srv 198.51.100.10 ─ ether3 ┘
   (DMZ: web 80, SSH 22, MySQL 3306)
```

La empresa tiene tres **zonas**:

- **LAN** (`ether2`): los PCs de los empleados. Lo más valioso.
- **DMZ** (`ether3`): el servidor público, con su web, su SSH de administración y su base de datos.
  Tiene IP pública (`198.51.100.10`): el proveedor le dio a la empresa ese bloque.
- **Internet** (`ether4`): el resto del mundo.

Ahora mismo r1 enruta entre las tres **sin filtrar nada**: desde Internet se llega al SSH y a la
base de datos del servidor, e incluso a los PCs de la LAN. Y si alguien comprometiera el servidor
de la DMZ, tendría vía libre hacia los empleados.

**La política que ha aprobado la empresa:**

| Desde ↓ / hacia → | LAN | DMZ | Internet |
|---|---|---|---|
| **LAN** | — | todo | todo |
| **DMZ** | **nada** (que no pueda iniciar conexiones) | — | todo |
| **Internet** | nada | **sólo la web (TCP 80)** | — |

Las respuestas de lo permitido tienen que volver, claro: que la DMZ no pueda *iniciar* conexiones
hacia la LAN no significa que no pueda *contestar* a un empleado que entra a su web.

**Objetivo:** implementar esa política en r1. El router en sí ya está protegido (cadena `input`) y la
LAN ya sale a Internet con NAT.

**Qué aprendes:**

- La cadena **`forward`**: el tráfico que **atraviesa** el router.
- Diseñar un firewall **por zonas** y escribirlo como una tabla de permisos.
- Por qué el seguimiento de conexiones (`established,related`) permite reglas **en un solo
  sentido**.
- La política de **denegar por defecto** (*default deny*).

Herramientas útiles: en los PCs, `nc -zv <ip> <puerto>`, `curl` y `ping`; en r1,
`/ip firewall filter print stats` y `/ip firewall connection print`.

`lab console r1` · `lab console pc1` · `lab console srv` · `lab console inet` · `lab check` · `lab hint`

> Los equipos ya están bien configurados: el reto se resuelve en r1. No toques las reglas `input`.
