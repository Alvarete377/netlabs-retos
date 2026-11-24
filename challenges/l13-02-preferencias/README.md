# Por la puerta barata

```
                 isp1 (AS 65101) ─────── isp2 (AS 65102)
  srv 198.51.100.10 ┘   │ 100.64.1.0/30       │ 100.64.2.0/30     192.0.2.0/24
                        └──── ether2  r1  ether3 ┘
                                (AS 65000)
                          ether4 │ 203.0.113.0/24
                                pc1 203.0.113.10
```

La empresa ya tiene BGP con sus dos operadores. Finanzas ha hecho números: isp2 cobra mucho menos
por tráfico. La nueva política es que **todo** entre y salga por isp2, y que isp1 quede sólo de
reserva por si isp2 cae.

Ahora mismo pasa lo contrario: hacia la red de isp1 se sale por isp1 (es el camino más corto), e
isp1 entrega el tráfico de la empresa directamente por su enlace.

**Objetivo:**

1. Toda la salida por isp2.
2. Toda la entrada por isp2 (isp1 debe preferir llegar a la empresa a través de isp2).
3. isp1 sigue de reserva y r1 sigue sin hacer de tránsito.

**Qué aprendes:**

- El orden de decisión de BGP: local-pref antes que AS-PATH.
- Controlar la salida (local-pref) frente a influir en la entrada (AS-path prepending).
- Filtros de entrada y salida en RouterOS 7.

`lab console r1` · `lab console isp1` · `lab check` · `lab hint`
