# Pregúntale a r1

```
 pc1 ── ether2 ── r1 ── ether3 ────── ether2 ── r2 ── ether3 ── srv 192.168.20.10
 192.168.1.0/24       172.16.12.0/30 (r1 .1, r2 .2)     192.168.20.0/24
 (sede)                                (centro de datos)
```

Los PCs de la sede tienen como DNS a r1 (`192.168.1.1`), pero r1 no contesta. El centro de datos
(r2, `172.16.12.2`) tiene el DNS de la empresa, que conoce `intranet.empresa.lab` y sabe preguntar por
el resto.

**Objetivo:** que r1 haga de **DNS con caché** para la sede: contesta a los PCs, reenvía a r2 lo que
no sabe y guarda las respuestas.

**Qué aprendes:**

- Cómo funciona una consulta DNS: cliente → resolvedor → servidor que sabe la respuesta.
- `/ip dns` en RouterOS: `servers`, `allow-remote-requests`, caché y registros estáticos.
- A leer `dig`: `ANSWER`, `SERVER`, TTL.

`lab console pc1` · `lab console r1` · `lab check` · `lab hint`
