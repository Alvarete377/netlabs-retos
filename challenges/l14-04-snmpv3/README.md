# SNMPv3

```
 mon 10.0.0.10 ── ether2 ─ r1 ─ ether3 ── srv 10.0.1.10
 (monitorización)          │
                         ether4 ── pc1 192.168.50.20 (oficina)
```
La monitorización ya funciona con SNMP v2c (`netlabs-ro`), pero auditoría ha visto la community
viajando en claro por la red. Hay que pasar a **SNMPv3** con autenticación y cifrado.

Credenciales: usuario `monitor`, autenticación SHA con `Autentica.2024`, cifrado AES con
`Cifrado.2024`.

**Objetivo:** que mon lea r1 y srv sólo con SNMPv3, con v1/v2c apagado en los dos, y que en r1 el
usuario sólo funcione desde mon.

**Qué aprendes:**

- Las diferencias entre v1, v2c y v3: communities frente a usuarios, `noAuthNoPriv`/`authNoPriv`/`authPriv`.
- SNMPv3 en RouterOS (`security=private`) y en net-snmp (`createUser`, `rouser`).

`lab console r1` · `lab console srv` · `lab console mon` · `lab console pc1` · `lab check` · `lab hint`
