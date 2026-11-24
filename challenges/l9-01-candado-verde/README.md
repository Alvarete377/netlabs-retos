# Candado verde

```
 pc1 192.168.1.10 ── ether2 ── r1 ── ether3 ── srv 192.168.20.10  (web.lab)
 (oficina)            192.168.1.1   192.168.20.1   (servidor web)
```

La intranet de la empresa por fin va a ir por **HTTPS**. La empresa tiene su propia autoridad de
certificación (**NetLabs CA Raiz**): sus claves están en `srv:/root/ca` y todos los puestos ya
confían en ella. r1 hace de DNS y ya resuelve `web.lab`. Sólo falta lo importante: el certificado del
servidor.

**Objetivo:**

1. Emite en srv un certificado para `web.lab` firmado por la CA de la empresa (que dure al menos 30 días).
2. Arranca la web con él (`servidor-https`) para que pc1 abra `https://web.lab` **sin avisos**.

**Qué aprendes:**

- Qué es una **CA**, una **CSR** y un certificado firmado.
- Por qué el nombre tiene que ir en el **subjectAltName**.
- A comprobar un certificado con `curl -v` y `openssl s_client`.

Herramientas útiles: `openssl req`, `openssl x509`, `openssl s_client`, `curl -v`.

`lab console srv` · `lab console pc1` · `lab check` · `lab hint`
