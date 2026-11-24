# Dos operadores mejor que uno

```
                 isp1 (AS 65101) ─────── isp2 (AS 65102)
  srv 198.51.100.10 ┘   │ 100.64.1.0/30       │ 100.64.2.0/30     192.0.2.0/24
                        └──── ether2  r1  ether3 ┘
                                (AS 65000)
                          ether4 │ 203.0.113.0/24
                                pc1 203.0.113.10
```

La empresa tiene su propio rango público (`203.0.113.0/24`) y su número de sistema autónomo
(AS 65000). Acaba de contratar una segunda salida a Internet para no depender de un solo operador.
Los dos operadores ya tienen preparada su parte; falta r1.

**Objetivo:**

1. Sesión eBGP de r1 con isp1 y con isp2.
2. Anunciar a los dos la red de la empresa.
3. **No hacer de tránsito** entre operadores.
4. pc1 llega a `198.51.100.10` (servidor de isp1).

**Qué aprendes:**

- eBGP con dos operadores (*multihoming*) en RouterOS 7.
- `output.network` y filtros de salida (`/routing filter rule`).
- Qué es un *route leak* y por qué una empresa nunca debe ser tránsito.

`lab console r1` · `lab console isp1` · `lab console isp2` · `lab check` · `lab hint`
