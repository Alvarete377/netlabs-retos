# Todos pasan por la central

```
 pc0 192.168.0.10                                         ┌── s1 (sede 1) ── pc1 192.168.1.10
        │                                    203.0.113.2  │   192.168.1.1/24
   hub (central) ── 198.51.100.2 ══ isp ═════════════════╡
   192.168.0.1/24                                         │
                                             203.0.113.6  └── s2 (sede 2) ── pc2 192.168.2.10
                                                              192.168.2.1/24
 Túneles WireGuard (10.255.0.0/24): hub .1 · s1 .2 · s2 .3 — en estrella, todos con la central
```

La empresa ha unido sus dos sedes a la central con **WireGuard en estrella**: cada sede tiene un
único túnel, con la central (`wg-sedes`, puerto UDP 51820), y para hablar entre ellas el tráfico
**pasa por la central**. Así, abrir una sede nueva sólo obliga a tocar la central.

La sede 1 se montó primero y "más o menos va". La sede 2 se montó el viernes copiando la
configuración de la sede 1. El lunes:

- La sede 2 **no llega a nada**.
- La sede 1 llega a la central, pero **no a la sede 2**.

**Objetivo:**

- Las tres LANs se hacen ping entre sí en todos los sentidos.
- Todo por WireGuard en estrella: cada sede tiene **un único túnel**, con la central. Nada de
  túneles directos entre sedes.
- El firewall de la central sigue terminando en `drop`.
- El proveedor (`isp`) no se toca.

> Es un reto difícil: hay **varios fallos**, repartidos entre la central y las dos sedes, y cada uno
> esconde al siguiente. Ve salto a salto.

**Qué aprendes:**

- La topología en **estrella** (*hub and spoke*) y por qué escala mejor que una malla.
- `allowed-address` como **tabla de rutas** de WireGuard: en la central decide a qué sede va cada
  paquete.
- Qué necesita cada salto (ruta, `allowed-address` y firewall) para que dos sedes se hablen a
  través de un tercero.
- A diagnosticar un túnel desde los dos extremos.

Herramientas útiles: `/interface wireguard peers print detail` (`last-handshake`, `rx`/`tx`),
`/ip route print`, `/ip firewall filter print stats`, `/ping ... src-address=...`.

`lab console hub` · `lab console s1` · `lab console s2` · `lab console pc0` … `pc2` · `lab check` · `lab hint`
