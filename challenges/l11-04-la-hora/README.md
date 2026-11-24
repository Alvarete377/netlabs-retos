# ¿Qué hora es?

```
 pc1 ── ether2 ── r1 ── ether3 ────── ether2 ── r2
 192.168.1.0/24       172.16.12.0/30 (r1 .1, r2 .2)   (centro de datos: servidor NTP)
```

Una auditoría ha encontrado que los logs de la sede no cuadran con los del centro de datos: hay
minutos de diferencia. La empresa tiene su referencia de hora en r2 (servidor NTP); falta que r1 la
use y, a su vez, se la dé a los equipos de la sede.

**Objetivo:** r1 sincroniza por **NTP** con r2 y hace de servidor NTP para la sede.

**Qué aprendes:**

- Para qué sirve NTP y qué son los **estratos**.
- Cliente y servidor NTP en RouterOS 7.
- A comprobar un servidor NTP desde Linux sin tocar el reloj.

`lab console r1` · `lab console pc1` · `lab check` · `lab hint`
