# El bucle maldito

```
            sw1 (raíz)
  pc1 ─ether4─┤   ├─ether3──────┐
              ether2            │
                │               │
              ether2          ether3
               sw2 ═ether3══ether2═ sw3 ─ether4─ pc2
              (enlace apagado)
```

pc1 y pc2 se hablan hoy a través del enlace directo sw1–sw3. Hay un tercer switch, sw2, colgado de
sw1, y un cable que lo une con sw3. El administrador anterior **apagó ese puerto (ether3 de sw2)
"porque al conectarlo se caía la red"**. Y tenía razón: ningún bridge corre STP, así que el
triángulo es un bucle de capa 2.

Quieres que ese enlace esté activo como camino de respaldo, **sin bucles**. Haz que los tres switches
usen **RSTP**, que **sw1 sea el bridge raíz** y **sw2 el raíz secundario** (prioridades `0x1000` y
`0x2000`), y después activa el puerto de sw2 hacia sw3.

**Qué aprendes:** bucles y tormentas de broadcast, RSTP, elección del bridge raíz (`priority`),
roles de puerto (root, designated, alternate) y por qué conviene fijar la raíz a mano.

> **Aviso:** si activas el puerto antes de tener STP, crearás un bucle y los switches se volverán
> lentos. Si pasa, vuelve a desactivarlo (`/interface bridge port set [find interface=ether3] disabled=yes`
> en sw2) y espera unos segundos.

Herramientas útiles: `/interface bridge print`, `/interface bridge port print`,
`/interface bridge monitor br1 once`. RSTP tarda unos segundos en converger.

> Los PCs ya están bien configurados: no los toques.
