# La planta nueva

```
                         ether2 ══════════ ether2
                    ┌──── sw1 ──────────────── sw2 ────┐
               ether3│   │ether4             ether4│ │ether5     ether3
                     │  pc1 (VLAN 10)        pc2 (10) pc5 (30)
                     │                                  │
               ether3│                                  │ether2
                    └──── sw4 ──────────────── sw3 ────┘
                     ether2 ══════════════════ ether3
                      │ether4 │ether5             │ether4
                     pc4 (20) pc6 (30)           pc3 (20)

   VLAN 10 Oficina:   pc1 192.168.10.11   pc2 192.168.10.12
   VLAN 20 Voz:       pc3 192.168.10.21   pc4 192.168.10.22
   VLAN 30 Invitados: pc5 192.168.10.31   pc6 192.168.10.32
```

La empresa ha estrenado planta: cuatro switches en **anillo** (para que un cable cortado no deje a
nadie sin red) y tres VLANs: **Oficina (10)**, **Voz (20)** e **Invitados (30)**. Todos los PCs
están en la misma subred IP a propósito: **lo único que separa las VLANs es la capa 2**.

El instalador se fue diciendo que "estaba todo hecho". Desde entonces:

- La gente de oficina de la primera planta no ve a la de la segunda.
- Seguridad ha detectado que **desde un PC de oficina se llega a los de invitados**. Eso es grave.
- Voz e invitados, de momento, funcionan.

El diseño acordado era: **sw1 es el núcleo y debe ser el bridge raíz de RSTP**; los cuatro enlaces
del anillo son trunks que llevan las tres VLANs etiquetadas; cada PC está en un puerto de acceso de
su VLAN.

**Objetivo:** que cada VLAN funcione de punta a punta, que **ninguna VLAN vea a otra**, y que la red
quede como se diseñó: sw1 como raíz, RSTP y filtrado de VLANs activos en los cuatro switches y los
cuatro enlaces del anillo en servicio (la redundancia no se toca).

> Aviso de alguien que ya lo ha intentado: "arreglé una cosa y de repente dejó de funcionar todo lo
> que iba bien". No es mala suerte.

**Qué aprendes:**

- A pensar el **árbol de STP** antes que las VLANs: por qué enlaces viaja *realmente* el tráfico y
  cuáles están bloqueados.
- Que un enlace bloqueado puede **esconder fallos** que aparecen el día que entra en servicio.
- La **VLAN nativa** (lo que viaja sin etiqueta por un trunk) y cómo un desajuste entre los dos
  extremos **mezcla VLANs**.
- A diagnosticar de forma **sistemática**, enlace a enlace, comparando los dos extremos de cada trunk.

Herramientas útiles: `/interface bridge monitor br1 once`, `/interface bridge port print`
(columnas de rol y estado de STP con `print detail`), `/interface bridge vlan print`,
`/interface bridge port print detail`, `/interface bridge host print`, y en los PCs `ping` y
`tcpdump -e -i eth1`.

`lab console sw1` … `lab console sw4` · `lab console pc1` … `lab console pc6` · `lab check` · `lab hint`

> Los PCs ya están bien configurados: el reto se resuelve en los switches, no los toques.
