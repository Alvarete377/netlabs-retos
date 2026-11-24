# Monitorización ciega

```
 mon 10.0.0.10 ── ether2 ─ r1 ─ ether3 ── srv 10.0.1.10
 (monitorización)          │
                         ether5 ── ether2 ─ r2 172.16.12.2
```
Lunes, 8:00. El panel de monitorización lleva todo el fin de semana en gris: mon no recibe nada. Ni
SNMP de r2 ni de srv, ni un solo log de los routers. El viernes "sólo se tocaron un par de cosas".

Lo que debería funcionar: mon lee r1, r2 y srv por SNMP v2c con la community `netlabs-ro`, y r1 y r2
le mandan sus logs por syslog (UDP 514), que mon guarda en `/var/log/remoto/`.

**Objetivo:** devolverle la vista a mon sin abrir de más: r2 sigue con su firewall terminando en
drop, su community sólo vale para mon y srv no responde a `public`.

**Qué aprendes:**

- Diagnóstico por partes: quién no llega a quién y por qué.
- Que un timeout de SNMP puede ser red, firewall, community, dirección permitida o el agente caído.
- A leer contadores del firewall y el journal de un servicio.

`lab console mon` · `lab console srv` · `lab console r1` · `lab console r2` · `lab check` · `lab hint`
