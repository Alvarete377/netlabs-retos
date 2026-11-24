# La copia que nunca se hizo

Hoy había que restaurar un fichero de ayer… y en `/var/backups/datos` no hay ninguna copia de las
últimas semanas. Y eso que el timer `copia.timer` se lanza cada noche y systemd dice que el servicio
terminó bien. El script es `/usr/local/bin/copia`.

**Objetivo:** que `systemctl start copia.service` haga una copia válida de `/srv/datos` en
`/var/backups/datos`, aunque una copia anterior muriese a medias; que la rotación deje sólo las 7
más recientes sin tocar nada más (en esa carpeta hay un `LEEME.txt` que no se puede borrar); que si
no hay datos, falle; y que no queden copias tiradas fuera de su sitio.

**Qué aprendes:**

- Scripts defensivos: `set -euo pipefail`, comillas, valores por defecto (`${VAR:-...}`).
- Cerrojos de verdad con `flock`.
- Que el entorno de systemd no es el de tu terminal, y rotar sin borrar lo que no toca.

`lab console srv` · `lab check` · `lab hint`
