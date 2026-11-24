# Una VPN para el cliente

```
              10.0.12.0/30            10.0.23.0/30
 pc1 ── ether3 ── pe1 ── ether2 ──── p ──── ether2 ── pe2 ── ether3 ── pc2
 192.168.1.0/24   10.255.0.1          10.255.0.2         10.255.0.3   192.168.2.0/24
 (cliente, sede 1)          (operador: núcleo MPLS)                   (cliente, sede 2)
```

El núcleo MPLS ya funciona (OSPF + LDP). Llega el primer cliente con dos sedes, conectadas a pe1 y a
pe2 por ether3. Quiere unirlas como si fuera una red privada, y el operador quiere que su tráfico
vaya **aislado**: ni el núcleo ve sus redes ni el cliente ve el núcleo.

**Objetivo:** montar una **VPN de nivel 3 MPLS** (RFC 4364): una VRF por PE y rutas del cliente
intercambiadas por BGP VPNv4 entre pe1 y pe2.

**Qué aprendes:**

- VRF: tablas de rutas separadas en un mismo router.
- BGP VPNv4, *route distinguisher* y *route target*.
- Las dos etiquetas de una VPN MPLS y por qué p no necesita saber nada del cliente.

`lab console pe1` · `lab console pe2` · `lab console pc1` · `lab check` · `lab hint`
