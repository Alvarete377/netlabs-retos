# La CPU por las nubes

El servidor va lento y la gráfica de CPU está siempre arriba. Alguien ya reinició el proceso
"sospechoso" un par de veces, pero al rato vuelve a estar ahí. El usuario `pedro` dejó la empresa
hace meses... y su cuenta sigue activa.

**Objetivo:** encontrar qué se come la CPU, pararlo, quitar todo lo que lo vuelve a lanzar y bloquear
la cuenta de pedro.

**Qué aprendes:**

- `top`, `ps` y `/proc/<PID>`: qué ejecuta de verdad un proceso y quién lo lanzó.
- Procesos que se disfrazan y procesos que reviven.
- Dónde se esconde lo programado: crontabs de usuario y timers de systemd.

`lab console srv` · `lab check` · `lab hint`
