# Reconocimiento

```
 srv 192.168.10.10 ──────── pc1 192.168.10.20
```

Te acaban de dar acceso de root a un servidor que no conoces. Antes de tocar nada, toca saber qué hay:
qué sistema es, qué escucha, quién puede entrar y qué se ha dejado olvidado alguien.

**Objetivo:** responde con `lab answer` las cinco preguntas (`lab status` las lista) y quita del
servidor la contraseña que encuentres, dejando el resto de ese fichero como estaba.

**Qué aprendes:**

- A orientarte en un Linux desconocido: `/etc/os-release`, `/etc/passwd`, `ss`.
- A buscar: `find`, `grep -r`, `ls -lS`, `du`.
- Que los ficheros ocultos (`.algo`) también cuentan.

`lab console srv` · `lab console pc1` · `lab check` · `lab hint`
