# El puerto que no sale

```
 pc1 10.0.0.20 ──────── srv 10.0.0.10
 (oficina)              (Podman)
```
Han montado la intranet en un contenedor (`web`, un nginx) en srv. En el propio servidor parece que
va, pero desde la oficina (pc1) `http://10.0.0.10:8080/` no carga nada.

**Objetivo:** que pc1 vea la intranet en `http://10.0.0.10:8080/`, servida por el contenedor `web` y
con la página que hay en `/srv/intranet` del servidor.

**Qué aprendes:**

- `podman ps`, `podman inspect` y `podman port`.
- La red propia de un contenedor y por qué hay que publicar puertos (`-p`).
- Que un contenedor se borra y se recrea, y qué se conserva (lo montado con `-v`).

`lab console srv` · `lab console pc1` · `lab check` · `lab hint`
