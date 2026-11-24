# El script que miente

`/usr/local/bin/limpiar-logs` debería borrar los logs de más de 7 días de `/srv/app/logs`. Cada
mañana dice «limpieza hecha»… y el disco se sigue llenando. Los logs que más sobran son los de la
aplicación nueva, que pone espacios en los nombres.

**Objetivo:** que el script haga lo que dice (también con espacios y en subcarpetas), sin tocar lo
que no debe, y que cuando no pueda, **lo diga** con un código de salida de error.

**Qué aprendes:**

- Comillas, espacios en nombres y por qué `for f in $(find ...)` es una trampa.
- Códigos de salida, `set -euo pipefail` y `bash -x` para depurar.
- `find` con `-mtime`, `-delete` y `-exec`.

`lab console srv` · `lab check` · `lab hint`
