# El MTU traicionero

```
 pc1 192.168.1.10                                                             srv 192.168.30.10
        │                       MTU 1400                                            │
     ether2 ── r1 ── ether3 ═══════════ ether2 ── r2 ── ether3 ════ ether2 ── r3 ── ether3
 192.168.1.1/24   10.0.12.1/30       10.0.12.2/30    10.0.23.1/30  10.0.23.2/30   192.168.30.1/24
   sucursal            (enlace contratado)                         (firewall de servidores)
```

Desde la sucursal, el servidor de informes funciona "a medias": `http://192.168.30.10/` carga al
instante, pero `http://192.168.30.10/informe` (un informe largo) **se queda colgado** para siempre.
No hay ningún error: simplemente no termina.

El enlace entre r1 y r2 es un servicio contratado con **MTU 1400** y no se puede cambiar. Y el
responsable de seguridad no quiere que se pueda hacer **ping** a los servidores.

**Objetivo:**

1. Averigua el MTU del tramo más estrecho del camino y respóndelo con `lab answer`.
2. Consigue que el informe se descargue entero, **sin** tocar el enlace contratado y **sin** abrir los
   pings hacia los servidores.

Este reto tiene **preguntas**: respóndelas con `lab answer` (cuentan para `lab check`).

**Qué aprendes:**

- Qué es el **MTU** y cómo medirlo con `ping` y el bit **no fragmentar**.
- Cómo funciona el **Path MTU Discovery** y por qué depende de un mensaje ICMP.
- Qué es un **agujero negro de MTU** y por qué "bloquear todo el ICMP" rompe cosas.

Herramientas útiles: en pc1, `curl`, `ping -M do -s <tamaño>` y `traceroute`; en los routers,
`/ping ... size=<n> do-not-fragment` y `/ip firewall filter print stats`.

`lab console pc1` · `lab console r1` … `lab console r3` · `lab console srv` · `lab answer` · `lab check` · `lab hint`
