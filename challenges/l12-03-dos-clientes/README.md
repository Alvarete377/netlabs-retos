# Dos clientes, las mismas IPs

```
 pcA1 192.168.1.10 ─ ether3 ┐                                         ┌ ether3 ─ pcA2 192.168.2.10
                            pe1 ── p ── pe2
 pcB1 192.168.1.20 ─ ether4 ┘   (núcleo MPLS)                         └ ether4 ─ pcB2 192.168.2.20
```

El operador ya tiene al cliente A funcionando con su VPN (VRF `cliA`). Ayer se dio de alta el
cliente B, que, como todo el mundo, usa `192.168.1.0/24` y `192.168.2.0/24`. Lo configuró un técnico
nuevo copiando la VRF de A... y B no funciona. Peor aún: seguridad sospecha que B ve cosas de A.

**Objetivo:**

1. A sigue funcionando.
2. Las dos sedes de B se comunican.
3. Ningún cliente llega a las máquinas del otro.

**Qué aprendes:**

- Cómo separan las VPN MPLS a clientes con redes solapadas (RD) y quién se queda cada ruta (RT).
- `export.redistribute`, `import/export.route-targets` en RouterOS 7.
- Que en un operador, una fuga entre clientes es más grave que un corte.

`lab console pe1` · `lab console pe2` · `lab console pcB1` · `lab check` · `lab hint`
