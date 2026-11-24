# El resolvedor abierto

```
 inet 203.0.113.10 ── ether2 ── r1 ── ether3 ── pc1 192.168.1.10
 (Internet)        203.0.113.1    192.168.1.1   (oficina)
```

El operador ha mandado un correo serio: la IP `203.0.113.1` (r1) aparece en sus listas como
**resolvedor DNS abierto** y se está usando en ataques. Si no se arregla, cortan la línea.

r1 hace de DNS para la oficina (`allow-remote-requests=yes`) y tiene un firewall en `input`...
que alguien "retocó" cuando soporte se quejó de que el DNS no iba.

**Objetivo:**

1. Que desde Internet nadie pueda usar r1 como DNS (ni UDP ni TCP).
2. Que la oficina siga resolviendo con r1.
3. Desde Internet, r1 sólo contesta al ping. El input termina en un drop general.

**Qué aprendes:**

- Qué es un resolvedor abierto y cómo se usa en ataques de **amplificación**.
- DNS por UDP y por TCP.
- Por qué en RouterOS una cadena sin drop final lo acepta todo.

`lab console inet` · `lab console r1` · `lab console pc1` · `lab check` · `lab hint`
