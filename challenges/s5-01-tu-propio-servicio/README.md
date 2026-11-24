# Tu propio servicio

El panel de informes (`/opt/informes/panel.py`, HTTP en el 8080) lo arranca alguien a mano con
`python3 panel.py &` cada vez que se cae, como root y desde su sesión. Cuando se reinicia el servidor,
nadie se acuerda.

**Objetivo:** convertirlo en un servicio de systemd llamado `informes`, que corra como el usuario
`informes`, arranque con el sistema y vuelva solo si el proceso muere.

**Qué aprendes:**

- Escribir una unidad `.service`: `[Unit]`, `[Service]`, `[Install]`.
- `daemon-reload`, `enable`, `start`, `status` y el PID principal.
- `Restart=` y por qué un servicio no debe correr como root.

`lab console srv` · `lab check` · `lab hint`
