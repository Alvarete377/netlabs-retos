# Los logs que nadie lee

```
 pc1 ── ether2 ── r1 ── ether3 ────── ether2 ── r2 ── ether3 ── srv 192.168.20.10
 192.168.1.0/24       172.16.12.0/30 (r1 .1, r2 .2)     192.168.20.0/24
 (sede)                                (centro de datos)
```

Tras un incidente, nadie pudo reconstruir qué había pasado: los routers guardan los logs sólo en
memoria y se perdieron al reiniciar. La empresa ha montado un **servidor de logs** (srv,
`192.168.20.10`, syslog en UDP 514).

**Objetivo:**

1. r1 y r2 mandan sus avisos y errores a srv.
2. Los mensajes informativos no se mandan (sólo meterían ruido).
3. Los routers siguen guardando sus logs en memoria, como hasta ahora.

**Qué aprendes:**

- Acciones y reglas de `/system logging` en RouterOS; los **temas**.
- Syslog remoto: qué es, puerto, limitaciones.
- A comprobar lo que llega con `tail -f` en el colector.

`lab console r1` · `lab console r2` · `lab console srv` · `lab check` · `lab hint`
