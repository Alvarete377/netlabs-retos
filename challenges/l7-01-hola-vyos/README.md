# Hola, VyOS

```
 pc1 192.168.1.10                                                          pc2 192.168.2.10
   gw 192.168.1.1                                                            gw 192.168.2.1
        │                                                                          │
     ether2 ── r1 (MikroTik) ── ether3 ═══════ eth1 ── vy1 (VyOS) ── eth2
   192.168.1.1/24          172.16.12.1/30   172.16.12.2/30             192.168.2.1/24
       central                                                             filial
```

La empresa ha comprado una filial que trabaja con routers **VyOS**, un sistema de router de código
abierto basado en Linux, con una forma de trabajar muy parecida a la de los grandes fabricantes
(Juniper, por ejemplo): **primero se escribe la configuración y luego se confirma**.

La central (r1, MikroTik) ya está lista: tiene su LAN, el enlace con la filial y una ruta hacia la
LAN de la filial. El router de la filial (`vy1`) está recién sacado de la caja.

**Objetivo:** configurar `vy1` para que pc1 y pc2 se hagan ping en los dos sentidos:

- `eth1`: `172.16.12.2/30` (enlace con la central).
- `eth2`: `192.168.2.1/24` (LAN de la filial, puerta de enlace de pc2).
- Una **ruta estática** hacia la LAN de la central.

**Qué aprendes:**

- El modelo de **configuración con confirmación**: `configure` → `set` → `commit` → `save`.
- La diferencia entre la configuración **en curso** y la **guardada**.
- Que en VyOS las interfaces se llaman como en Linux (`eth1`), sin el desfase de MikroTik.
- A traducir lo que ya sabes de RouterOS a otro fabricante.

Herramientas útiles en VyOS: `show interfaces`, `show ip route`, `ping`, y en modo configuración
`show`, `compare` y `commit`.

`lab console vy1` · `lab console r1` · `lab console pc1` · `lab console pc2` · `lab check` · `lab hint`

> Este módulo usa routers **VyOS**. Si es la primera vez, construye su imagen una sola vez con
> `bash images/build-vyos.sh` (descarga ~650 MB); `lab up` te avisará si falta.
