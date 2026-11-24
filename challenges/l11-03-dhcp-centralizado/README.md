# Un DHCP para todas las sedes

```
 pc1 ── ether2 ── r1 ── ether3 ────── ether2 ── r2 ── ether3 ── srv 192.168.20.10
 192.168.1.0/24       172.16.12.0/30 (r1 .1, r2 .2)     192.168.20.0/24
 (sede)                                (centro de datos)
```

La empresa centraliza el DHCP: en lugar de que cada router de sede reparta direcciones, lo hace un
único servidor en el centro de datos (r2). En r2 ya están preparados el pool de la sede 1
(`192.168.1.100-199`) y los datos de su red, pero falta poner el servidor en marcha... y que las
peticiones de la sede le lleguen.

pc1 acaba de enchufarse y pide IP por DHCP sin parar.

**Objetivo:** que pc1 reciba su IP del servidor central y llegue a la red de servidores.

**Qué aprendes:**

- Por qué el DHCP no cruza routers (broadcast).
- **DHCP relay**: giaddr y cómo elige el servidor el pool.
- `/ip dhcp-relay` y `relay=` en el servidor de RouterOS.

`lab console r1` · `lab console r2` · `lab console pc1` · `lab check` · `lab hint`
