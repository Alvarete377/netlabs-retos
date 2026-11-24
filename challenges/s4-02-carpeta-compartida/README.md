# La carpeta del departamento

Ventas comparte documentos en `/srv/compartido/ventas`. Ahora mismo es de root y nadie más puede escribir, así que
se los mandan por correo. Quieren:

- **ana** y **luis** (grupo `ventas`): crear, leer y modificar, también lo que haya creado el otro.
- **pedro** (grupo `marketing`): leer, sin escribir.
- **eva** (grupo `rrhh`) y el resto: ni entrar.

**Objetivo:** dejar la carpeta así sin dar permisos a «otros» (nada de 777).

**Qué aprendes:**

- Permisos de carpeta: qué significan `r`, `w` y `x` en un directorio.
- El bit setgid en carpetas compartidas.
- ACLs (`setfacl`, `getfacl`) y ACLs por defecto frente a la umask.

`lab console srv` · `lab check` · `lab hint`
