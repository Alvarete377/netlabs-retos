# A mano funciona

«Si lo lanzo yo, va.» El informe diario de ventas (`/usr/local/bin/informe-diario`) funciona
perfectamente cuando el administrador lo ejecuta desde `/var/informes`, pero por las mañanas no
aparece ningún informe nuevo. La tarea está en `/etc/cron.d/informe`, a las 07:00.

**Objetivo:** que funcione cuando lo lanza cron, que sus mensajes (y errores) lleguen al journal con
la etiqueta `informe-diario`, y que si falla termine con error.

**Qué aprendes:**

- El entorno de cron: PATH, carpeta de trabajo, sin `.bashrc`.
- Rutas absolutas en scripts automáticos.
- `logger` y `journalctl -t` para no perder la salida.

`lab console srv` · `lab check` · `lab hint`
