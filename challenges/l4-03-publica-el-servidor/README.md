# Publica el servidor

```
 pc1 192.168.1.10 ─ ether2 ┐
                           ├ bridge "lan" 192.168.1.1/24 ── r1 ── ether4 203.0.113.1/24 ── inet 203.0.113.10
 web 192.168.1.20 ─ ether3 ┘                                       (IP pública)            ("Internet")
   web en el 80, SSH en el 22
```

La oficina tiene un servidor web interno (`web`, `192.168.1.20`) con la página de la empresa. Ahora
el jefe quiere que **los clientes puedan verla desde Internet**. El problema: el servidor tiene una
IP privada y lo único que Internet conoce de la oficina es la IP pública de r1, `203.0.113.1`.

El proveedor sólo te deja usar puertos altos, así que la web se publicará en
**`http://203.0.113.1:8080`**.

Ojo: ese servidor tiene también un **SSH de administración** en el puerto 22. Eso **no** debe verse
desde Internet bajo ningún concepto.

**Objetivo:**

- Desde Internet (`inet`) se abre la web en `http://203.0.113.1:8080`.
- El servidor ve la **IP real** del visitante (para sus estadísticas y sus registros).
- **Sólo** se publica la web: ni el 22 ni ningún otro puerto llegan al servidor desde Internet.
- Desde la LAN, el servidor se sigue usando por su IP interna.

r1 ya tiene el NAT de salida de la oficina y el router en sí protegido (los dos retos anteriores).

**Qué aprendes:**

- **NAT de destino** (`dstnat`, *port forwarding*): cambiar el destino de lo que entra.
- Traducir también el **puerto** (8080 fuera → 80 dentro).
- Por qué hay que **acotar** la regla (interfaz, protocolo y puerto) y qué pasa si no.
- El orden real del procesado: el `dstnat` ocurre **antes** de decidir la ruta y el filtrado.

Herramientas útiles: en `inet`, `curl http://203.0.113.1:8080/` y `nc -zv 203.0.113.1 22`; en r1,
`/ip firewall nat print stats` y `/ip firewall connection print`.

`lab console r1` · `lab console inet` · `lab console web` · `lab console pc1` · `lab check` · `lab hint`

> Los equipos ya están bien configurados: el reto se resuelve en r1.
