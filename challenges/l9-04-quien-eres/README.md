# ¿Quién eres?

```
 pc1 192.168.1.10 ── ether2 ──┐
 (administrador)              r1 ── ether3 ── srv 192.168.20.10  (admin.lab)
 pc2 192.168.2.10 ── ether4 ──┘
 (invitados)
```

El panel de administración `https://admin.lab` va por HTTPS, pero cualquiera que llegue a él ve
el formulario. Seguridad no quiere más contraseñas: quiere que sólo entre quien tenga un
**certificado de cliente** emitido por la CA de la empresa.

En `srv:/root/ca` tienes la CA (raiz.crt y raiz.key). El script `servidor-https` exige certificado de
cliente si existe `/etc/web/ca-clientes.crt`.

**Objetivo:**

1. Emite un certificado de cliente para pc1 y haz que su curl lo use.
2. Activa la verificación de clientes en el servidor.
3. pc2 debe seguir llegando al puerto 443, pero el servidor no le deja pasar del saludo TLS.

**Qué aprendes:**

- **TLS mutuo** (mTLS): autenticar al cliente con certificado.
- Diferencia entre certificado de servidor (`serverAuth`) y de cliente (`clientAuth`).
- Mover ficheros entre máquinas con `nc`.

`lab console srv` · `lab console pc1` · `lab console pc2` · `lab check` · `lab hint`
