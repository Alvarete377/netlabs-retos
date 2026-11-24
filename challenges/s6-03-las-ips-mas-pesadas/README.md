# Las IPs más pesadas

Cada vez que la web va lenta, alguien se pone a mirar el log de nginx a ojo para ver quién está
haciendo tantas peticiones. Toca un script que lo haga solo.

**Objetivo:** `/usr/local/bin/top-ips [-n N] FICHERO`, que saque las N IPs (3 por defecto) con más
peticiones de un log de acceso de nginx, de más a menos, con el formato `veces ip`:

```
root@srv:~# top-ips /var/log/nginx/acceso-ejemplo.log
27 10.2.1.14
24 10.1.3.7
21 10.3.2.22
```

(Tus IPs serán otras: el log de ejemplo se genera al azar.) Si el fichero no existe, aviso por la
salida de error y código de salida 2.

**Qué aprendes:**

- Tuberías para analizar texto: `awk`, `sort`, `uniq -c`, `head`.
- Opciones con `getopts`, argumentos y códigos de salida.
- Escribir scripts que otros (y otros scripts) puedan usar.

`lab console srv` · `lab check` · `lab hint`
