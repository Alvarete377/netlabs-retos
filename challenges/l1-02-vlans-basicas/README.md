# Separa a los de contabilidad

```
 pc1 10.0.0.1 ──ether2──┐
 pc2 10.0.0.2 ──ether3──┤ sw1
 pc3 10.0.0.3 ──ether4──┘
```

pc1 y pc2 son de contabilidad (VLAN 10). pc3 es de invitados (VLAN 20). Están todos en la misma
subred IP y el jefe no quiere renumerar: la separación tiene que hacerse en el switch.

**Objetivos:** pc1 ↔ pc2 sí; pc3 no debe llegar a ninguno de los dos.

**Qué aprendes:** VLANs, puertos de acceso, `pvid` y `vlan-filtering` en el bridge de RouterOS.

`lab console sw1` · `lab console pc1` · `lab check` · `lab hint`

> Los PCs ya están bien configurados: el reto se resuelve en los switches, no los toques.
