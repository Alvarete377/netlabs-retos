# Tu primer switch

```
 pc1 (192.168.10.1) ──ether2── [ sw1 ] ──ether3── pc2 (192.168.10.2)
```

Los dos PCs están en la misma red, pero no se ven. `sw1` es un MikroTik recién sacado de la caja:
cada puerto va por su lado.

**Objetivo:** que pc1 y pc2 se hagan ping.

**Qué aprendes:** qué es un bridge (un switch por software) y cómo se añaden puertos.

- Entra al switch: `lab console sw1` (usuario `admin`, contraseña `admin`)
- Prueba desde un PC: `lab console pc1` y `ping 192.168.10.2`
- Comprueba: `lab check` · Pistas: `lab hint`

> `ether1` es la interfaz de gestión del laboratorio: no la toques.

> Los PCs ya están bien configurados: el reto se resuelve en los switches, no los toques.
