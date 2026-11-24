# sudo a medida

El técnico de **soporte** tiene que poder reiniciar nginx cuando se cuelga y mirar su log. Para ir
rápido, alguien lo metió en el grupo `sudo`: ahora puede hacer **cualquier cosa** como root.

**Objetivo:**

- soporte reinicia nginx con `sudo systemctl restart nginx`, sin contraseña.
- soporte lee `journalctl -u nginx` (sin sudo).
- Y nada más: ni otros servicios, ni una shell de root.
- ana, la administradora, sigue con sudo completo.

**Qué aprendes:**

- `sudoers` y `/etc/sudoers.d/`, `visudo`, `sudo -l`.
- Mínimo privilegio y por qué algunos comandos con sudo son una puerta a root.
- Grupos del sistema que dan permisos concretos (`systemd-journal`, `adm`).

`lab console srv` · `lab check` · `lab hint`
