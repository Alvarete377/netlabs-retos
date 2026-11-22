# IPsec entre fabricantes

```
 pc1 192.168.1.10                                                                pc2 192.168.2.10
        │                                                                                │
     ether2 ── r1 (MikroTik) ── ether3 ═══ ether2 ── isp ── ether3 ═══ eth1 ── vy1 (VyOS) ── eth2
  192.168.1.1/24          198.51.100.2/30                          203.0.113.2/30         192.168.2.1/24
      central                                  │ ether4                                       filial
                                         srv 192.0.2.10 (web de Internet)
```

La central (MikroTik) y la filial (VyOS) tienen que unirse con **IPsec** por Internet. El
responsable de seguridad ha dejado clara la **política de la empresa** para cualquier VPN:

| | Fase 1 (IKE) | Fase 2 (ESP) |
|---|---|---|
| Versión | IKEv2 | — |
| Cifrado | AES-256 | AES-256 |
| Integridad | SHA-256 | SHA-256 |
| Diffie-Hellman | grupo 14 (2048 bits) | PFS con grupo 14 |
| Autenticación | clave compartida `Central-Filial-2026` | — |

El técnico de la central montó su lado **hace tiempo** (peer, identity y policy ya existen), sin
mirar la política. La filial no tiene nada. Las dos sedes salen a Internet con NAT y tienen que
seguir haciéndolo.

**Objetivo:**

- pc1 y pc2 se hacen ping en los dos sentidos por el túnel IPsec.
- El túnel cumple la política **en las dos fases y en los dos extremos**.
- Las dos sedes siguen navegando con su IP pública (`http://192.0.2.10/` te dice con qué IP te ve).
- El proveedor no se toca.

> Es un reto difícil: hay más de un problema y unos tapan a otros. Ve por partes.

**Qué aprendes:**

- Que en IPsec entre fabricantes **las propuestas tienen que coincidir exactamente**, y que los
  valores por defecto de cada uno **no** son iguales.
- La configuración IPsec de VyOS (grupos IKE y ESP, autenticación, peer y túnel).
- A diagnosticar una negociación fallida con los registros de los dos lados.
- La exención de NAT, ahora en dos fabricantes distintos.

Herramientas útiles: en la central, `/ip ipsec profile print`, `/ip ipsec proposal print`,
`/ip ipsec active-peers print`, `/log print where topics~"ipsec"`, `/ip firewall nat print stats`;
en VyOS, `show vpn ipsec sa`, `show log`, `show nat source statistics`.

`lab console r1` · `lab console vy1` · `lab console pc1` · `lab console pc2` · `lab console isp` · `lab check` · `lab hint`

> Este módulo usa routers **VyOS**. Si es la primera vez, construye su imagen una sola vez con
> `bash images/build-vyos.sh` (descarga ~650 MB); `lab up` te avisará si falta.
