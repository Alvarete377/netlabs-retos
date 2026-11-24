# La mudanza

```
 pc1 10.0.0.20 ──────── srv 10.0.0.10
 (oficina)              (Podman)
```
La tienda online se ha "mudado" del viejo servidor en Python a un contenedor nginx gestionado por
systemd (`container-tienda`). La persona que hizo la migración se fue a mitad, y desde la oficina
`http://10.0.0.10:8080/` enseña la tienda antigua... cuando enseña algo.

**Objetivo:** que pc1 vea la tienda nueva, servida por el contenedor `tienda` bajo systemd, que vuelva
sola si se cae, que la antigua quede apagada para siempre, y todo sin quitar las protecciones del
contenedor (raíz de sólo lectura y web montada en sólo lectura).

**Qué aprendes:**

- Diagnosticar contenedores que gestiona systemd (`status`, `journalctl`, `podman logs`).
- Conflictos de puertos entre el servidor y los contenedores.
- Contenedores de sólo lectura (`--read-only`, `--tmpfs`) sin rebajar la seguridad.

`lab console srv` · `lab console pc1` · `lab check` · `lab hint`
