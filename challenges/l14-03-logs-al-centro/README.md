# Logs al centro

```
 mon 10.0.0.10 ── ether2 ─ r1 ─ ether3 ── srv 10.0.1.10
 (monitorización)          │
                         ether4 ── pc1 192.168.50.20 (oficina)
```
Cuando algo falla a las tres de la mañana, nadie quiere entrar equipo por equipo a leer logs. La idea
es que todos manden sus logs a `mon` por syslog y que allí se guarden ordenados.

**Objetivo:** que mon reciba por UDP 514 los logs de r1 (los de tipo info, al menos) y de srv, y los
guarde en `/var/log/remoto/`, **un fichero por equipo**, sin mezclarlos con sus propios logs.

**Qué aprendes:**

- syslog: facility, severidad, UDP 514.
- rsyslog como servidor: `imudp`, plantillas y `stop`; y como cliente: `@` y `@@`.
- `/system logging` en RouterOS.

`lab console mon` · `lab console srv` · `lab console r1` · `lab check` · `lab hint`
