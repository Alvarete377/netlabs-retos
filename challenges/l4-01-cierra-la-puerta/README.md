# Cierra la puerta

```
 pc1 192.168.1.10/24                              inet 203.0.113.10/24
   gw 192.168.1.1                                   ("Internet")
        │                                                │
     ether2 ─────────────── r1 ─────────────── ether3
   192.168.1.1/24                             203.0.113.1/24
        LAN                                      Internet
```

Acabas de conectar el router de la oficina a Internet y alguien te enseña los registros: desde
fuera están probando contraseñas contra su **SSH**, su **web de administración** y **Winbox**. El
router no tiene ni una regla de firewall que lo proteja: cualquiera en Internet puede llamar a su
puerta.

**Objetivo:** proteger **el propio router** con el firewall:

- Desde Internet (`inet`) **no** se puede llegar a ninguno de sus servicios de administración.
- Desde Internet **sí** se le puede hacer **ping** (ICMP no se cierra a lo loco: sirve para
  diagnosticar).
- Desde la LAN (`pc1`) se administra **con normalidad** (SSH, web, ping).
- El propio router puede seguir haciendo ping a Internet y **descargando** cosas de ella (por
  ejemplo, actualizaciones): **las respuestas a lo que él inicia tienen que entrar**.

**Reglas del reto:**

- Se resuelve con `/ip firewall filter`. **No** vale apagar los servicios (`/ip service disable`)
  ni limitarlos por dirección: en una red real también se hace, pero aquí se trata de aprender el
  firewall. Además, `lab` entra al router por SSH: si lo apagas o lo limitas, el laboratorio se
  queda sin acceso y `lab check` no podrá comprobarte.
- La primera regla de `input` es la **gestión del laboratorio** por `ether1`: por ahí entra `lab`
  para configurar y comprobar. **No la borres ni pongas reglas encima**: si te quedas fuera, el
  laboratorio no puede comprobarte (en la vida real, esto se llama "cortar la rama en la que estás
  sentado").

**Qué aprendes:**

- Las cadenas del firewall de RouterOS: **`input`** (tráfico dirigido al router), **`forward`**
  (tráfico que lo atraviesa) y **`output`** (lo que sale del router).
- El **seguimiento de conexiones**: `connection-state` = `new`, `established`, `related`, `invalid`.
- Que el orden importa: **la primera regla que encaja decide**.
- El patrón base de cualquier firewall: aceptar lo establecido, tirar lo inválido, permitir lo
  justo y descartar el resto.

Herramientas útiles: `/ip firewall filter print`, `/ip firewall filter print stats` (contadores
por regla), `/ip firewall connection print`, `/ping` en el router, y en los PCs `nc -zv <ip> <puerto>`
y `ping`.

`lab console r1` · `lab console pc1` · `lab console inet` · `lab check` · `lab hint`

> Los PCs ya están bien configurados: el reto se resuelve en el router, no los toques.
