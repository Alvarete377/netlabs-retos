# Disco lleno

```
 srv 192.168.10.10 ──────── pc1 192.168.10.20
 /srv/datos (64M): clientes.db, facturas.log, copia-2023.tar
```

El servicio que emite las facturas se ha parado y no hay manera de que siga: dicen que el disco de
datos está lleno, pero quien lo mira no encuentra qué lo ocupa.

La copia `copia-2023.tar` ya está archivada en cinta y se puede borrar. `clientes.db` y el
histórico de `facturas.log` **no** se tocan.

**Objetivo:** que `facturas` vuelva a funcionar con `/srv/datos` por debajo del 25 %, sin agrandar
ni desmontar el disco, y que lo que lo llenaba no vuelva a hacerlo.

**Qué aprendes:**

- `df` frente a `du`, y por qué a veces no cuadran.
- Ficheros borrados que siguen abiertos: `lsof +L1` y `/proc/<PID>/fd`.
- Que systemd relanza servicios con `Restart=`: parar y desactivar, no sólo matar.

`lab console srv` · `lab console pc1` · `lab check` · `lab hint`
