# Sin memoria

```
 pc1 10.0.0.20 ──────── srv 10.0.0.10
 (oficina)              (Podman)
```
El contenedor `informes` sirve el informe diario en el puerto 8081. Esta mañana nadie lo ve desde la
oficina, y en el servidor el contenedor aparece parado. Lo arrancas a mano y vuelve a caerse.

**Objetivo:** que `informes` funcione (pc1 lo ve en `http://10.0.0.10:8081/`) con un límite de memoria
sensato, y que lo gestione systemd: que arranque con el servidor y vuelva solo si muere.

**Qué aprendes:**

- Leer el estado y el código de salida de un contenedor (`ps -a`, `logs`, `inspect`).
- Límites de memoria con cgroups (`--memory`) y qué pasa al pasarse.
- Contenedores como servicios de systemd con `podman generate systemd`.

`lab console srv` · `lab console pc1` · `lab check` · `lab hint`
