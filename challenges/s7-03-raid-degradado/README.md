# RAID degradado

```
 srv (máquina virtual Debian 12)
   vdb 512 MB ─┐
               ├─ md0 (RAID 1) ─ ext4 ─ /srv/contabilidad
   vdc 512 MB ─┘   ← ha fallado
   vdd 512 MB ─ ?
```

La contabilidad de la empresa está en un **RAID 1 por software** (`md0`): dos discos con los mismos datos,
para que la caída de uno no pare nada. Esta noche ha fallado uno; el servidor sigue funcionando con el
otro, pero **un fallo más y se pierde todo**. El técnico ha conectado esta mañana un disco nuevo.

**Objetivos:**

1. Averigua el estado del RAID, qué disco ha fallado y cuál es el nuevo.
2. Reconstruye el RAID con el disco nuevo, **sin desmontar** `/srv/contabilidad`.
3. No vuelvas a meter el disco averiado.
4. Al terminar: RAID limpio (dos discos sincronizados) y datos intactos.

**Qué aprendes:** RAID por software con `mdadm`, leer `/proc/mdstat`, reconstruir un RAID y por qué RAID
no es una copia de seguridad.

Herramientas útiles: `cat /proc/mdstat`, `mdadm --detail /dev/md0`, `mdadm --examine`, `lsblk -f`.

`lab console srv` · `lab check` · `lab hint`
