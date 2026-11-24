# La cadena rota

```
 pc1 192.168.1.10 ── ether2 ── r1 ── ether3 ── srv 192.168.20.10
 (oficina)            192.168.1.1   192.168.20.1   (intranet: web.lab)
               r1 hace de DNS para la oficina
```

El administrador anterior migró la intranet a un servidor nuevo y a la **CA intermedia** de la
empresa (la raíz se guarda offline). Desde entonces nadie entra en `https://web.lab`: primero "no
carga" y, según quién lo cuente, "sale un aviso de certificado".

Los puestos confían en la raíz (**NetLabs CA Raiz**). En `srv:/root/ca` tienes la intermedia con su
clave; la web se arranca con `servidor-https` (lee `/etc/web/servidor.crt` y `servidor.key`).

**Objetivo:** que pc1 vuelva a abrir `https://web.lab` sin avisos, con el certificado bien emitido
por la intermedia y servido como debe.

**Qué aprendes:**

- Diagnosticar HTTPS por capas: nombre → IP → puerto → certificado.
- Qué es una **cadena de certificados** y quién debe mandar la intermedia.
- A leer `curl -v` y `openssl s_client -showcerts`.

`lab console pc1` · `lab console r1` · `lab console srv` · `lab check` · `lab hint`
