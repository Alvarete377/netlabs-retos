# ¿Dónde se pierde?

```
 pc1 192.168.1.10                                                              pc2 192.168.4.10
        │                                                                              │
     ether2 ── r1 ── ether3 ══ ether2 ── r2 ── ether3 ══ ether2 ── r3 ── ether3 ══ ether2 ── r4 ── ether3
 192.168.1.1/24   10.0.12.1/30  10.0.12.2/30   10.0.23.1/30 10.0.23.2/30  10.0.34.1/30 10.0.34.2/30  192.168.4.1/24
```

pc1 no llega a pc2. Hay cuatro routers en medio y **uno** de ellos tiene el problema. Antes de
cambiar nada, el responsable quiere saber **cuál** y **por qué**.

**Objetivo:**

1. Averigua en qué router está el fallo **sin tocar la configuración** y respóndelo con
   `lab answer`.
2. Después, arréglalo: pc1 y pc2 se hacen ping en los dos sentidos. Sin NAT.

Este reto tiene **preguntas**: respóndelas con `lab answer` (cuentan para `lab check`).

**Qué aprendes:**

- A leer un `traceroute` y lo que significan los `* * *`.
- A **dividir el camino** probando desde los routers intermedios, con `src-address`.
- Que todo viaje tiene **ida y vuelta**, y que la vuelta también hay que comprobarla.

Herramientas útiles: en los PCs, `ping` y `traceroute -n`; en los routers, `/ping`,
`/tool traceroute` e `/ip route print`.

`lab console r1` … `lab console r4` · `lab console pc1` · `lab console pc2` · `lab answer` · `lab check` · `lab hint`
