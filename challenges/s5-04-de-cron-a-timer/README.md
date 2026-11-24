# De cron a timer

La copia diaria de la web la lanza cron a las 02:30 (`/etc/cron.d/copia-web`). Problemas: si el
servidor está apagado a esa hora, ese día no hay copia, y cuando falla nadie se entera porque la
salida se tira a `/dev/null`.

**Objetivo:** pasarla a un **timer de systemd** (`copia-web.timer` + `copia-web.service`) que la lance
cada día a las 02:30, recupere las que se pierdan con el servidor apagado y deje sus mensajes en el
journal. Y quitarla de cron.

**Qué aprendes:**

- Timers de systemd: `OnCalendar=`, `Persistent=`, `list-timers`.
- Servicios `Type=oneshot`.
- Cron frente a timers, y `systemd-analyze calendar`.

`lab console srv` · `lab check` · `lab hint`
