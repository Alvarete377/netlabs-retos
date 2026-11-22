# WireGuard entre sedes

```
 pc1 192.168.1.10                                                              pc2 192.168.2.10
   gw 192.168.1.1                                                                gw 192.168.2.1
        │                                                                              │
     ether2 ── r1 ── ether3 ═══════ ether2 ── isp ── ether3 ═══════ ether2 ── r2 ── ether3
  192.168.1.1   198.51.100.2/30   198.51.100.1      203.0.113.1    203.0.113.2/30   192.168.2.1
   (sede 1)       IP pública        ("Internet")                    IP pública        (sede 2)
```

Las mismas dos sedes. Esta vez la dirección no quiere un túnel en claro: lo que va de una sede a otra
tiene que ir **cifrado**. Se ha elegido **WireGuard**.

Alguien ya ha creado en cada router la interfaz `wg-sedes`, con su **par de claves** generado. Falta
todo lo demás: que cada router conozca al otro, la red del túnel y las rutas.

**Objetivo:** que pc1 y pc2 se hagan ping en los dos sentidos por un túnel WireGuard entre r1 y r2.
El proveedor no se toca.

**Qué aprendes:**

- Cómo se autentica WireGuard: **claves públicas**, no contraseñas. Qué se comparte y qué no.
- Qué es un **peer**, el **endpoint** y el **keepalive**.
- **`allowed-address`**: el campo que a la vez filtra lo que se acepta y decide qué va por el túnel.
- A diagnosticar con **`last-handshake`**.

Herramientas útiles: `/interface wireguard print` (aquí ves las claves públicas),
`/interface wireguard peers print detail`, `/ip route print`, `/ping`.

`lab console r1` · `lab console r2` · `lab console isp` · `lab console pc1` · `lab console pc2` · `lab check` · `lab hint`

> Los PCs, la salida a Internet y las interfaces `wg-sedes` ya están bien configurados. No toques el
> router del proveedor.
