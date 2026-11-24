# Puerto ocupado

```
 srv 192.168.10.10 ──────── pc1 192.168.10.20
```

Tras una actualización, la intranet de srv ya no carga: en su lugar sale un panel de 2019 que
nadie usa. nginx está instalado, pero no hay forma de que arranque.

**Objetivo:** que nginx sirva la intranet en el puerto 80 y que el panel antiguo no vuelva.

**Qué aprendes:**

- Leer por qué falla un servicio: `systemctl status` y `journalctl -u`.
- Quién escucha en un puerto: `ss -ltnp`.
- `stop` frente a `disable`, y por qué matar un proceso a veces no sirve.

`lab console srv` · `lab console pc1` · `lab check` · `lab hint`
