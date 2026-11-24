# ¿Quién escucha?

```
 pc1 192.168.1.10 ── ether2 ── r1 ── ether3 ── srv 192.168.20.10
 (LAN de administración)  192.168.1.1   192.168.20.1   (servidor de la empresa)
```

Te acaban de dar acceso a la red de administración y nadie te ha pasado el inventario del servidor
`192.168.20.10`. Sabes que tiene SSH, un correo, una base de datos y "un panel web en algún puerto raro".

**Objetivo:**

1. Investiga el servidor desde pc1 y responde con `lab answer`:
   - qué **versión de Postfix** anuncia su correo;
   - en qué **puerto TCP** escucha el panel web (el firewall no te deja verlo).
2. Deja que la LAN de administración abra el panel en el navegador... **sólo el panel**: la base de
   datos sigue sin verse desde la LAN.

Este reto tiene **preguntas**: respóndelas con `lab answer` (cuentan para `lab check`).

**Qué aprendes:**

- Las tres respuestas de un puerto TCP: **abierto**, **cerrado** y **filtrado**, y qué dice cada una.
- A leer el **banner** de un servicio con `nc`, `curl telnet://` o el `telnet` de RouterOS.
- A recorrer puertos con `nmap`.
- A abrir **sólo lo justo** en un firewall con una regla encima de la que bloquea.

Herramientas útiles: en pc1, `nmap`, `nc -v -w 3`, `curl -v telnet://...`; en r1,
`/tool fetch`, `/system telnet` y `/ip firewall filter print stats`.

`lab console pc1` · `lab console r1` · `lab console srv` · `lab answer` · `lab check` · `lab hint`
