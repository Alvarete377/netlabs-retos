# Conectando con el proveedor

```
 pc1 192.168.1.10/24                                                   srv 203.0.113.10
   gw 192.168.1.1                  (sin IP: PPPoE)                      (web de Internet)
        │                                                                     │
     ether2 ─────── r1 ─────── ether3 ═══════ ether2 ── isp ── ether3 ────────┘
   192.168.1.1/24                              servidor PPPoE   203.0.113.1/24
```

La oficina ha contratado fibra. El técnico del proveedor ha dejado el cable conectado a `ether3` de
r1 y una nota:

> Acceso por **PPPoE**. Usuario: **`oficina`** · Contraseña: **`N3tL4bs`**.
> La IP pública es dinámica: se asigna al conectar.

Y nada más. El enlace no lleva IP fija: hasta que r1 no abra la sesión PPPoE, no hay Internet.

**Objetivo:**

- r1 establece la sesión PPPoE con el proveedor y sale a Internet por ella.
- `pc1` navega por la web del servidor de Internet (`http://203.0.113.10/`), saliendo con la IP que
  el proveedor asigna a la oficina.
- El router del proveedor no se toca.

**Qué aprendes:**

- Qué es **PPPoE** y por qué lo usan los proveedores de fibra y ADSL: autenticación por usuario y
  contraseña, IP dinámica y control por cliente.
- Que el cliente PPPoE es una **interfaz** más (`pppoe-out1`), montada sobre la física.
- Por qué el NAT y las rutas van sobre la interfaz PPPoE, no sobre `ether3`.
- La **MTU de 1492** de PPPoE y por qué a veces da problemas.

Herramientas útiles: `/interface pppoe-client print`, `/interface pppoe-client monitor pppoe-out1
once`, `/ip address print`, `/ip route print`, `/ip firewall nat print`; en `pc1`, `curl` y `ping`.

`lab console r1` · `lab console isp` · `lab console pc1` · `lab console srv` · `lab check` · `lab hint`

> Los equipos ya están bien configurados: el reto se resuelve en r1. No toques el router del proveedor.
