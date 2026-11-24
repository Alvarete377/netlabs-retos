# Etiquetas en el núcleo

```
              10.0.12.0/30            10.0.23.0/30
        pe1 ── ether2 ──────── p ──────── ether2 ── pe2
     10.255.0.1           10.255.0.2           10.255.0.3      (loopbacks)
```

Bienvenido al operador. El núcleo de la red (pe1, p, pe2) ya enruta con OSPF: cada router llega a
las loopbacks de los demás. El siguiente paso para dar servicios a clientes (VPN de nivel 3, VPLS...)
es convertirlo en un núcleo **MPLS**.

**Objetivo:** que los tres routers repartan etiquetas con **LDP**: p con dos vecinos operativos y
los PE con etiqueta para llegar a la loopback del otro.

**Qué aprendes:**

- Qué es una etiqueta MPLS y por qué se usa (conmutar sin mirar la IP, base de las VPN de operador).
- LDP: vecinos, direcciones de transporte, tabla de reenvío MPLS.
- *Penultimate hop popping* e *implicit null*.

`lab console pe1` · `lab console p` · `lab console pe2` · `lab check` · `lab hint`
