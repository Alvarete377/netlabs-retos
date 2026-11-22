# La filial heredada

```
 pc1 192.168.1.10                                                                      pc2 192.168.4.10
        │                                                                                      │
     ether2 ── r1 ── ether3 ════ ether2 ── r2 ── ether3 ════ ether2 ── r3 ── ether3 ════ ether2 ── r4 ── ether3
  192.168.1.1/24   10.0.12.1/30  10.0.12.2/30    10.0.23.1/30  10.0.23.2/30   10.0.34.1/30 10.0.34.2/30  192.168.4.1/24
                 └──────── OSPF área 0 ────────┘└────────── OSPF área 1 ─────────┘└────────── RIP ──────────┘
     central                              (ABR)                           (ASBR)          router heredado
```

La empresa ha comprado una filial. Su router (`r4`) es antiguo y **sólo habla RIP**, así que se
montó `r3` como frontera: habla RIP con `r4` y OSPF con el resto, y traduce entre los dos.

El diseño de la red, aprobado por el responsable, es este:

- `r1` y `r2` en el **área 0**; el enlace `r2`–`r3` y `r3`, en el **área 1**.
- El **área 1 no debe recibir las rutas externas** del resto de la empresa (hay más redistribuciones
  en otras sedes y no se quieren en la filial).
- `r3` inyecta en OSPF las redes de la filial (aprendidas por RIP) y le cuenta a `r4`, por RIP,
  cómo llegar a la central.

Quien lo montó se fue antes de probarlo. Nada funciona.

**Objetivo:** que pc1 y pc2 se hagan ping en los dos sentidos **respetando el diseño**. Sin rutas
estáticas y sin NAT.

> Es un reto difícil: hay **varios fallos** de tipos distintos y unos tapan a otros. Arreglar uno
> puede no cambiar nada visible hasta que arreglas el siguiente. Ve de la central hacia la filial.

**Qué aprendes:**

- Qué parámetros tienen que coincidir para formar una vecindad OSPF.
- Las áreas especiales de OSPF: **stub** frente a **NSSA**, y qué pasa con las rutas externas en
  cada una.
- La redistribución en los **dos sentidos** entre RIP y OSPF.
- A diagnosticar por capas: vecindades → base de datos (LSAs) → tabla de rutas → camino de vuelta.

Herramientas útiles: `/routing ospf neighbor print`, `/routing ospf interface-template print detail`,
`/routing ospf area print`, `/routing ospf lsa print`, `/ip route print where ospf`,
`/routing rip instance print`, `/routing rip route print`.

`lab console r1` … `lab console r4` · `lab console pc1` · `lab console pc2` · `lab check` · `lab hint`
