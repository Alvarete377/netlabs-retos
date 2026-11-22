# IPsec y el NAT traicionero

```
 pc1 192.168.1.10                                                              pc2 192.168.2.10
   gw 192.168.1.1                                                                gw 192.168.2.1
        │                                                                              │
     ether2 ── r1 ── ether3 ═══════ ether2 ── isp ── ether3 ═══════ ether2 ── r2 ── ether3
  192.168.1.1   198.51.100.2/30   198.51.100.1      203.0.113.1    203.0.113.2/30   192.168.2.1
   (sede 1)       IP pública        ("Internet")                    IP pública        (sede 2)
                                      │ ether4
                                     srv 192.0.2.10 (web de Internet)
```

Las dos sedes otra vez. Uno de los routers con los que la empresa tendrá que conectar en el futuro es
de otro fabricante, así que se ha decidido usar el estándar: **IPsec** con **IKEv2** y una clave
compartida, `Sedes-Unidas-2026`.

Las dos sedes ya salen a Internet con NAT (masquerade). Eso tiene que seguir funcionando.

**Objetivo:**

- pc1 y pc2 se hacen ping en los dos sentidos.
- El tráfico entre LANs va **cifrado con IPsec** (no vale GRE ni WireGuard).
- Las dos sedes siguen navegando por Internet con su IP pública (`http://192.0.2.10/` te dice con qué
  IP te ve).
- El proveedor no se toca.

> Aviso: es muy probable que llegues a un punto en el que **el túnel está arriba y aun así no pasa
> nada**. Ése es el corazón del reto.

**Qué aprendes:**

- Las piezas de IPsec en RouterOS: **peer**, **identity** y **policy**.
- Las **dos fases** (IKE y las SA) y cómo comprobar cada una.
- Que IPsec funciona **por políticas**, sin interfaz ni rutas.
- La trampa más famosa de las VPN: el **NAT** actuando antes que IPsec.

Herramientas útiles: `/ip ipsec active-peers print`, `/ip ipsec policy print`,
`/ip ipsec installed-sa print`, `/ip firewall nat print stats`, `/log print`; en los PCs, `ping` y
`curl http://192.0.2.10/`.

`lab console r1` · `lab console r2` · `lab console isp` · `lab console pc1` · `lab console pc2` · `lab check` · `lab hint`

> Los PCs, la salida a Internet y el servidor ya están bien configurados. No toques el router del
> proveedor.
