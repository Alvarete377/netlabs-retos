# No se ven

```
 pc1 10.0.0.20 ──────── srv 10.0.0.10
 (oficina)              (Podman)
```
La `api` (puerto 8082) consulta cada pocos segundos el estado que publica el contenedor `datos`. Desde
la oficina, `http://10.0.0.10:8082/` sólo dice `SIN CONEXION CON datos`, y eso que los dos
contenedores están en marcha en el mismo servidor.

**Objetivo:** que `api` encuentre a `datos` por su nombre, en una red de contenedores `interna`, que pc1
vea `estado: OK`, y que `datos` deje de estar publicado hacia fuera.

**Qué aprendes:**

- Las redes de Podman/Docker: la de por defecto y las que creas tú.
- Resolución de nombres entre contenedores.
- Qué publicar (`-p`) y qué dejar sólo dentro.

`lab console srv` · `lab console pc1` · `lab check` · `lab hint`
