# Dos cables mejor que uno

```
                 ether2 ═══════════ ether2
 pc1 ── ether4  sw1                 sw2  ether4 ── pc2
 192.168.10.1    ether3 ═══════════ ether3      192.168.10.2
```

Entre los dos switches de la oficina hay **dos cables**, para que si uno se rompe no se corte nada.
RSTP está activado y hace su trabajo: como dos cables entre los mismos switches forman un bucle,
**bloquea uno de ellos**. La red funciona, pero el segundo cable está de adorno: sólo se usa la
mitad del ancho de banda.

La jefa quiere los dos cables **trabajando a la vez** sin perder la redundancia.

**Objetivo:** agrupar los dos enlaces entre sw1 y sw2 con **LACP (802.3ad)**, de modo que:

- pc1 y pc2 se sigan comunicando;
- los dos cables estén **activos a la vez** en el grupo;
- STP no bloquee ninguno (y siga activado, por si alguien conecta otro cable donde no debe).

**Qué aprendes:**

- Qué es la **agregación de enlaces** (*link aggregation*, *bonding*, *port-channel*, *LAG*): varios
  cables que se comportan como uno.
- Qué hace **LACP**: negociar el grupo con el otro extremo y sacar del grupo un cable que falla.
- Por qué STP deja de bloquear: ve **un único enlace lógico**.
- Que el reparto es **por flujo**, no por paquete: una sola conexión no va más rápido, pero muchas
  conexiones sí reparten.

Herramientas útiles: `/interface bridge port print` (mira los roles de STP), `/interface bonding
print`, `/interface bonding monitor bond1 once`, y `ping` en los PCs.

`lab console sw1` · `lab console sw2` · `lab console pc1` · `lab console pc2` · `lab check` · `lab hint`

> Los PCs ya están bien configurados: el reto se resuelve en los switches.
