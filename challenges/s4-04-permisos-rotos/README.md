# Permisos rotos

```
 navegador ──> nginx (www-data) ──> /srv/web/publico          (la web)
                     │
                     └── /subir/ ──> subidas.py (usuario subidas, 127.0.0.1:8000)
                                        └── guarda en /srv/web/publico/subidas/
```

La asociación tiene una web sencilla donde los socios suben documentos. Tras «ordenar» el
servidor, nada funciona: la web da error, las subidas fallan y, cuando funcionan, lo subido no se
puede descargar. De paso, la auditoría avisa de que **cualquier usuario puede hacerse root**.

Todo se prueba desde el propio servidor:

```
root@srv:~# curl -i http://127.0.0.1/
root@srv:~# echo hola > /tmp/a.txt
root@srv:~# curl -i -X PUT --data-binary @/tmp/a.txt http://127.0.0.1/subir/a.txt
root@srv:~# curl -i http://127.0.0.1/subidas/a.txt
```

**Objetivo:** que todo funcione con el mínimo privilegio (la aplicación como `subidas`, nginx sin
escritura, nada abierto a «otros») y cerrar la puerta a root.

**Qué aprendes:**

- Que para llegar a un fichero hace falta `x` en todo el camino (`namei -l`).
- La umask de un servicio (`UMask=`) y el setgid para que dos usuarios compartan ficheros.
- Buscar SUID peligrosos y por qué un `find` con SUID es una escalada a root.

`lab console srv` · `lab check` · `lab hint`
