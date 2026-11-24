# Red en Linux

```
 pc1 ──────────── gw ──────────── srv
 192.168.10.20    .1   10.20.0.1  10.20.0.10
      192.168.10.0/24     10.20.0.0/24
```
La intranet (nginx en srv) no carga desde pc1. Alguien "arregló" la red de srv con prisas y además
hay quien dice que el problema está en los PCs.

**Objetivo:** que pc1 cargue `http://intranet.lab/`, con srv bien configurado: su IP con la máscara
de su red y la ruta por defecto por gw.

**Qué aprendes:**

- `ip addr` e `ip route`: máscara, red conectada y ruta por defecto.
- Que la ida y la vuelta son caminos distintos.
- `/etc/hosts` frente a DNS, y quién gana.

`lab console srv` · `lab console gw` · `lab console pc1` · `lab check` · `lab hint`
