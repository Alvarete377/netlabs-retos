# La tienda que nadie ve

```
 inet 203.0.113.10 ── ether2 ── r1 ── ether3 ── srv 192.168.20.10  (tienda.lab: 443, panel: 8080)
 (Internet)        203.0.113.1  │   192.168.20.1
                                └── ether4 ── pc1 192.168.1.10  (oficina)
                                   192.168.1.1
```

La tienda online de la empresa (`https://tienda.lab`) está publicada en la IP pública
`203.0.113.1`. Hoy es el lanzamiento de la campaña y llegan quejas de todas partes: los clientes no la
ven, y en la oficina tampoco. Para colmo, alguien comenta que "el candado sale rojo".

En `srv:/root/ca` tienes la CA intermedia de la empresa. La web se arranca con `servidor-https`.

**Objetivo:**

1. Que la tienda se abra sin avisos desde Internet (inet) **y** desde la oficina (pc1).
2. Que el servidor presente un certificado vigente con su cadena.
3. Sin abrir de más: desde Internet no se ve el panel interno (8080), y la oficina sí.

**Qué aprendes:**

- Diagnosticar un servicio publicado capa a capa: NAT, firewall, TLS, DNS.
- El orden de las reglas del firewall y `connection-nat-state=dstnat`.
- **DNS partido** frente a **hairpin NAT**.
- Renovar un certificado caducado sin tocar la CA raíz.

`lab console inet` · `lab console r1` · `lab console srv` · `lab console pc1` · `lab check` · `lab hint`
