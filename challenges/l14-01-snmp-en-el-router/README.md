# SNMP en el router

```
 mon 10.0.0.10 ── ether2 ─ r1 ─ ether3 ── srv 10.0.1.10
 (monitorización)          │
                         ether4 ── pc1 192.168.50.20 (oficina)
```
El equipo de sistemas ha montado un servidor de monitorización (`mon`) y quiere vigilar r1: nombre,
interfaces, tráfico. r1 tiene SNMP apagado, y la community de fábrica es `public`.

**Objetivo:** que mon lea r1 por SNMP v2c con la community `netlabs-ro`, sólo lectura y sólo desde mon.
`public` no debe responder.

**Qué aprendes:**

- Qué es SNMP: agente, gestor, OIDs y MIBs (`SNMPv2-MIB::sysName.0`, `IF-MIB::ifName`).
- `/snmp` y `/snmp community` en RouterOS.
- `snmpget` y `snmpwalk` desde Linux.

`lab console r1` · `lab console mon` · `lab console pc1` · `lab check` · `lab hint`
