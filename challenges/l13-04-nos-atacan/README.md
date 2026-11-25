# Nos atacan

```
                 isp1 (AS 65101) ─────── isp2 (AS 65102)
  srv 198.51.100.10 ┘   │ 100.64.1.0/30       │ 100.64.2.0/30     192.0.2.0/24
                        └──── ether2  r1  ether3 ┘
                                (AS 65000)
              ether4 203.0.113.0/25 │    │ ether5 203.0.113.128/25 (DMZ)
                       pc1 203.0.113.10    web 203.0.113.130
```

Lunes, 9:00. La web de la empresa (`203.0.113.130`, en la DMZ) está recibiendo un ataque de
denegación de servicio desde la red de isp1: la línea con isp1 va saturada y **toda la empresa**
sufre. No da tiempo a contratar un servicio anti-DDoS; hay que cortar el ataque ya, aunque la web
se quede fuera de línea un rato.

isp1 ofrece a sus clientes **blackhole remoto** (RTBH). Sus condiciones:

> Anuncie por su sesión BGP la /32 atacada, dentro de su propio prefijo, con la community
> **`65101:666`**. La instalaremos como `blackhole` en nuestra red. No aceptamos otros prefijos más
> específicos que su /24.

isp2 no ofrece RTBH.

**Objetivo:**

1. isp1 tira el tráfico hacia `203.0.113.130` (la web deja de recibir el ataque).
2. El resto de la empresa sigue accesible (el servidor de isp1 llega a pc1).
3. A isp2 sólo se le anuncia `203.0.113.0/24`.

**Qué aprendes:**

- *Communities* BGP y cómo pedirle algo a un operador con ellas.
- RTBH: la defensa básica contra DDoS volumétricos y su precio.
- Cadenas de salida distintas por vecino en RouterOS 7.

`lab console r1` · `lab console isp1` · `lab console srv` · `lab check` · `lab hint`
