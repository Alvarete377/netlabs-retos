# El heredado

```
 pc1 ──────────── gw ──────────── srv
 192.168.10.20    .1   10.20.0.1  10.20.0.10
      192.168.10.0/24     10.20.0.0/24
```
Heredas el servidor de la tienda online de alguien que se fue de la empresa sin dejar notas. La
tienda no carga desde la oficina (pc1) y nadie sabe desde cuándo. Hay nginx delante y una pequeña
aplicación en Python detrás (`/srv/tienda`, servicio `tienda`), que cuenta las visitas.

**Objetivo:** que pc1 vea la tienda con el contador subiendo, sin atajos: la aplicación sigue
corriendo como `tienda`, su puerto interno no se abre fuera y nada queda con permisos 777.

**Qué aprendes:**

- Diagnosticar de abajo arriba: red, puerto, proxy, aplicación, permisos.
- A leer 502 y 500 de nginx y llegar a su causa con `journalctl`.
- Que un fallo puede esconder a los demás.

`lab console srv` · `lab console gw` · `lab console pc1` · `lab check` · `lab hint`
