# No arranca

```
 srv (máquina virtual Debian 12)
   vda ─ sistema
   vdb ─ vdb1 → /datos    (restaurado ayer de una copia)
       └ vdb2 → /copias
```

Ayer el disco de datos dio errores y se restauró de una copia sobre la misma partición. Esta mañana,
tras un reinicio programado, **el servidor no arranca**. No responde por la red: lo único que queda es
la **consola serie**, como si estuvieras delante de la pantalla del servidor.

```
lab console srv --serie      # salir: Ctrl+]  y luego  quit
```

**Objetivos:**

1. Entra por la consola serie y averigua por qué no arranca.
2. Arréglalo para que arranque solo, con `/datos` y `/copias` montados y los datos intactos.
3. Nada de esconder el problema con `nofail`: cada línea del fstab tiene que ser correcta.

La contraseña de **root** (sólo para la consola de emergencia) es **netlabs**.

**Qué aprendes:** cómo usa systemd el fstab en el arranque, el modo de emergencia, y a diagnosticar un
servidor que no arranca leyendo lo que te dice en vez de reinstalar.

Herramientas útiles: `systemctl --failed`, `journalctl -xb -p err`, `lsblk -f`, `blkid`, `mount -a`,
`systemctl daemon-reload`, `systemctl reboot`.

`lab console srv --serie` · `lab check` · `lab hint`
