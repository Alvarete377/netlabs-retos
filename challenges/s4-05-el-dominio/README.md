# El dominio

```
 dc1 10.0.0.10 ──────── pc1 10.0.0.20
 Samba AD: EMPRESA.LAB  (cliente Kerberos)
```

La empresa ya no gestiona usuarios servidor a servidor: tiene un **directorio activo** (Active
Directory) en `dc1`, montado con Samba. Las cuentas del dominio sirven para iniciar sesión en
cualquier equipo.

Toca organizar el departamento de ventas:

- Una unidad organizativa `Ventas` con **ana** (`Ventas.Ana2025`) y **luis** (`Ventas.Luis2025`).
- Un grupo `Ventas-Comercial` con los dos.
- Contraseñas de al menos 10 caracteres en todo el dominio.
- **marta** se ha ido: su cuenta se deshabilita, no se borra.

El administrador del dominio es `Administrator` (`Admin.Dominio1`), aunque como root en dc1 no te
hará falta. El dominio tarda unos 20 segundos en crearse al levantar el laboratorio.

**Qué aprendes:**

- Qué es un dominio de Active Directory: directorio, Kerberos, OUs, usuarios y grupos.
- Administrarlo con `samba-tool`.
- Iniciar sesión con Kerberos desde un cliente (`kinit`, `klist`).

`lab console dc1` · `lab console pc1` · `lab check` · `lab hint`
