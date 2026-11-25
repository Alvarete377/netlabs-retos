# Rutas de nadie

```
                 isp1 (AS 65101) ─────── isp2 (AS 65102)
  srv 198.51.100.10 ┘   │ 100.64.1.0/30       │ 100.64.2.0/30     192.0.2.0/24
                        └──── ether2  r1  ether3 ┘
                                (AS 65000)
                          ether4 │ 203.0.113.0/24
                                pc1 203.0.113.10
```

Anoche isp2 hizo una "migración de routers". Esta mañana:

- pc1 no llega al servidor de isp1 (`198.51.100.10`).
- Desde Internet, nadie llega a pc1 (`203.0.113.10`).
- isp2 dice que "por su lado todo está bien".

r1 tiene BGP con los dos operadores y anuncia bien su red. Lo que no hace es **mirar lo que le
llega**.

**Objetivo:**

1. pc1 llega al servidor de isp1 y el servidor llega a pc1.
2. r1 no acepta de los operadores rutas que no pueden ser buenas, pero sigue aprendiendo las
   legítimas (`198.51.100.0/24` y `192.0.2.0/24`).
3. Sin tocar los routers de los operadores ni tirar sesiones.

**Qué aprendes:**

- Por qué una ruta más específica gana aunque venga de fuera.
- Filtros de entrada en BGP: tu propio prefijo, bogons y longitud máxima.
- Secuestros de prefijo por error (o no) y cómo protegerte de tu operador.

`lab console r1` · `lab console isp2` · `lab check` · `lab hint`
