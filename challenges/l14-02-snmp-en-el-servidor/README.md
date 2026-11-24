# SNMP en el servidor

```
 mon 10.0.0.10 ── ether2 ─ r1 ─ ether3 ── srv 10.0.1.10
 (monitorización)          │
                         ether4 ── pc1 192.168.50.20 (oficina)
```
Ahora toca vigilar el servidor `srv`: cuánto disco le queda y cuánta carga tiene. Tiene `snmpd`
instalado, pero desde mon no responde.

**Objetivo:** que mon lea srv por SNMP v2c con la community `netlabs-ro` (nombre, discos y carga),
sólo desde mon, sin `public` y con snmpd arrancando con el sistema.

**Qué aprendes:**

- `snmpd.conf`: `agentaddress`, `rocommunity`, vistas (`view`, `-V`).
- MIBs de un servidor: `HOST-RESOURCES-MIB` (discos, procesos) y `UCD-SNMP-MIB` (carga).
- A leer por qué no arranca un servicio con `journalctl`.

`lab console srv` · `lab console mon` · `lab console pc1` · `lab check` · `lab hint`
