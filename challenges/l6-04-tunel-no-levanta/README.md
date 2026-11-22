# El túnel que no levanta

```
 pc1 192.168.1.10                                                              pc2 192.168.2.10
   gw 192.168.1.1                                                                gw 192.168.2.1
        │                                                                              │
     ether2 ── r1 ── ether3 ═══════ ether2 ── isp ── ether3 ═══════ ether2 ── r2 ── ether3
  192.168.1.1   198.51.100.2/30   198.51.100.1      203.0.113.1    203.0.113.2/30   192.168.2.1
   (central)       IP pública        ("Internet")                    IP pública        (sede 2)
```

La **central** (r1) recibe por WireGuard las conexiones de sus sedes. El diseño:

- La central **no llama** a nadie: espera (no tiene `endpoint` en sus peers). Así sirve igual para
  sedes con IP fija que con IP dinámica.
- Cada sede (aquí, r2) **llama** a la central (`endpoint` = IP pública de la central) y mantiene el
  túnel vivo con *keepalive*.
- La central está protegida por su firewall (sólo se administra desde su LAN).

Un compañero montó la sede 2 y la conexión con la central... y el túnel **no levanta**. Dice que lo
ha revisado todo dos veces.

**Objetivo:** que pc1 (central) y pc2 (sede 2) se hagan ping en los dos sentidos por el túnel, sin
cambiar el diseño: la central sigue sin `endpoint` y sigue protegida por su firewall. El proveedor no
se toca.

**Qué aprendes:**

- A diagnosticar WireGuard por orden: primero el **saludo** (`last-handshake`), luego el tráfico.
- Las cuatro causas típicas de un túnel WireGuard que no funciona.
- Que un firewall bien hecho puede ser la causa: hay que abrirle la puerta a la VPN.

Herramientas útiles: `/interface wireguard print`, `/interface wireguard peers print detail`,
`/ip firewall filter print stats`, `/ip route print`, `/ping`; en los PCs, `ping`.

`lab console r1` · `lab console r2` · `lab console isp` · `lab console pc1` · `lab console pc2` · `lab check` · `lab hint`

> Los PCs y la salida a Internet ya están bien configurados. No toques el router del proveedor ni la
> regla de gestión del laboratorio en r1.
