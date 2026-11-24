# Somos el tránsito de nadie

```
                 isp1 (AS 65101) ─────── isp2 (AS 65102)
  srv 198.51.100.10 ┘   │ 100.64.1.0/30       │ 100.64.2.0/30     192.0.2.0/24
                        └──── ether2  r1  ether3 ┘
                                (AS 65000)
                          ether4 │ 203.0.113.0/24
                                pc1 203.0.113.10
```

El viernes un consultor "ordenó" la configuración BGP de r1. El lunes llegan dos correos:

- isp1: *"Su AS 65000 nos está anunciando rutas de terceros. Revísenlo o filtraremos su sesión."*
- isp2: *"No tenemos sesión BGP con ustedes desde el viernes."*

Y desde dentro: "Internet va, pero lento, y desde fuera no nos encuentran".

Política de la empresa: anunciar sólo `203.0.113.0/24`, nunca ser tránsito, y salir por isp1
mientras funcione (isp2 de reserva).

**Objetivo:** las dos sesiones arriba, la red de la empresa anunciada a los dos (y nada más), sin
tránsito, isp1 como salida principal y pc1 llegando al servidor de isp1.

**Qué aprendes:**

- Diagnosticar BGP de punta a punta: sesión, anuncios, filtros, política.
- *Route leaks*, secuestros de prefijo y por qué se filtra en BGP.
- `remote.as`, `output.network`, filtros y local-pref en RouterOS 7.

`lab console r1` · `lab console isp1` · `lab console isp2` · `lab check` · `lab hint`
