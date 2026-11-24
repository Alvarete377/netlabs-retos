# El túnel mudo

```
              10.0.12.0/30            10.0.23.0/30
 pc1 ── ether3 ── pe1 ── ether2 ──── p ──── ether2 ── pe2 ── ether3 ── pc2
 192.168.1.0/24   10.255.0.1          10.255.0.2         10.255.0.3   192.168.2.0/24
 (cliente, sede 1)          (operador: núcleo MPLS)                   (cliente, sede 2)
```

El cliente tenía su VPN de nivel 3 funcionando entre sus dos sedes. Durante la ventana de
mantenimiento de anoche se "reorganizó" la configuración de los tres routers del núcleo y esta mañana
las sedes no se ven. El técnico de guardia jura que "BGP está bien configurado".

El núcleo debería tener OSPF (funciona), LDP entre los tres routers, iBGP VPNv4 entre las loopbacks
de los PE y la VRF `cliA` en cada PE con RD y RT `65000:1`.

**Objetivo:** que pc1 y pc2 vuelvan a comunicarse por la VPN, con el núcleo sano (BGP y LDP de
extremo a extremo) y el cliente aislado.

**Qué aprendes:**

- Diagnosticar una VPN MPLS por capas: IGP, LDP, BGP, VRF, plano de datos.
- Por qué BGP "bien" no basta: plano de control frente a plano de datos.
- `local.address`, route targets y `/mpls interface` en RouterOS 7.

`lab console pe1` · `lab console p` · `lab console pe2` · `lab console pc1` · `lab check` · `lab hint`
