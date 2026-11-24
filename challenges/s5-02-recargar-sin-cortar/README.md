# Recargar sin cortar

El tablón de avisos de la tienda (`tablon`, puerto 8080) lo consultan las pantallas de la entrada todo
el día. Hay que cambiar el aviso, pero **sin reiniciarlo**: las pantallas tienen la conexión abierta y
tardan un buen rato en reconectar si se corta.

**Objetivo:** que muestre `Cerrado por inventario el lunes` con el mismo proceso de siempre, y que la
próxima vez baste con `systemctl reload tablon`.

**Qué aprendes:**

- Señales: HUP, TERM, KILL, INT. `kill` y `systemctl kill`.
- `reload` frente a `restart`, y `ExecReload=`.
- Cambiar una unidad con `systemctl edit` (drop-ins).

`lab console srv` · `lab check` · `lab hint`
