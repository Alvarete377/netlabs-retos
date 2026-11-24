# En bucle

```
 catalogo.service (tienda, :8080) ──Requires──> cache.service (tienda, 127.0.0.1:6380)
      │
      └── EnvironmentFile=... (dónde están los productos)
```

Tras «revisar la configuración» del servidor de la tienda, el catálogo no hay forma de que arranque.
Alguien lo ha intentado veinte veces con `systemctl restart` y ahora systemd ni lo intenta.

**Objetivo:** que el catálogo responda en `http://127.0.0.1:8080/` con sus 5 productos, con la caché en
marcha y todo arrancando con el sistema, **sin quitar las protecciones**: el catálogo sigue como
`tienda`, con `Restart=on-failure` y un límite de memoria de 512 MB como mucho, sin swap.

**Qué aprendes:**

- A leer el journal de un servicio que falla: el primer error manda.
- Dependencias (`Requires=`, `After=`), `EnvironmentFile=`, límites (`MemoryMax=`) y el OOM killer.
- El límite de arranques (`StartLimitBurst=`) y `reset-failed`.

`lab console srv` · `lab check` · `lab hint`
