# OSPF entre fabricantes

```
 pc1 192.168.1.10                                                          pc2 192.168.2.10
   gw 192.168.1.1                                                            gw 192.168.2.1
        │                                                                          │
     ether2 ── r1 (MikroTik) ── ether3 ═══════ eth1 ── vy1 (VyOS) ── eth2
   192.168.1.1/24          172.16.12.1/30   172.16.12.2/30             192.168.2.1/24
       central                                                             filial
```

La central (MikroTik) ya habla **OSPF** en el área backbone por el enlace con la filial
(router-id `10.255.255.1`, enlace `172.16.12.0/30`, su LAN como pasiva). El router de la filial
(`vy1`, VyOS) tiene las IPs puestas pero no sabe nada de OSPF.

La empresa no quiere rutas estáticas entre sedes: cuando abran más filiales, todo tiene que
aprenderse solo.

**Objetivo:** que `vy1` hable OSPF con la central (vecinos en `Full` en los dos lados) y que cada
uno aprenda la LAN del otro por OSPF, de modo que pc1 y pc2 se hagan ping. Sin rutas estáticas.

**Qué aprendes:**

- Que OSPF es un **estándar**: dos fabricantes distintos se entienden si coinciden en lo que el
  estándar exige (área, subred, temporizadores, tipo de red, router-id único).
- La configuración de OSPF en VyOS y su equivalencia con RouterOS.
- A comprobar una vecindad **desde los dos lados**, con las herramientas de cada fabricante.

Herramientas útiles: en VyOS, `show ip ospf neighbor`, `show ip ospf interface`, `show ip route`;
en la central, `/routing ospf neighbor print` y `/ip route print where ospf`.

`lab console vy1` · `lab console r1` · `lab console pc1` · `lab console pc2` · `lab check` · `lab hint`

> Este módulo usa routers **VyOS**. Si es la primera vez, construye su imagen una sola vez con
> `bash images/build-vyos.sh` (descarga ~650 MB); `lab up` te avisará si falta.
