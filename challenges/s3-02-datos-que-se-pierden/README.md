# Datos que se pierden

```
 pc1 10.0.0.20 ──────── srv 10.0.0.10
 (oficina)              (Podman)
```
El contenedor `registro` apunta cada pedido en `/datos/registro.txt`, con el histórico de meses
anteriores al principio. Mañana toca actualizarlo, lo que significa borrar el contenedor y crearlo de
nuevo... y nadie ha mirado dónde se guardan los datos.

**Objetivo:** que el registro viva en `/srv/registro` del servidor (montado en `/datos`), sin perder el
histórico, y con el contenedor `registro` funcionando como antes.

**Qué aprendes:**

- La capa de escritura de un contenedor y por qué es desechable.
- Montar carpetas del servidor (`-v`) y la diferencia con un volumen con nombre.
- `podman cp` e `inspect` para recrear un contenedor sin perder nada.

`lab console srv` · `lab console pc1` · `lab check` · `lab hint`
