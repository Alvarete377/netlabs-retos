# Datos cifrados

```
 srv (máquina virtual Debian 12)
   vda ─ sistema   (/root/nominas.csv, en claro)
   vdb ─ 512 MB, nuevo y vacío
```

Una auditoría ha encontrado las **nóminas** de la empresa en claro en `/root/nominas.csv`. Si alguien se
llevara el disco, podría leerlas. Han añadido un disco nuevo (`/dev/vdb`) para guardarlas **cifradas**.

**Objetivos:**

1. Cifra **todo** `/dev/vdb` con **LUKS2**.
2. Ábrelo con el nombre **secreto**, formatéalo en ext4 y móntalo en **/secreto**.
3. Que al arrancar se desbloquee y se monte solo, con un **fichero de clave** que sólo pueda leer root
   (`/etc/crypttab` + `/etc/fstab`).
4. Mueve las nóminas a `/secreto`: que no quede copia en `/root`.

**Qué aprendes:** cifrado de disco con LUKS2 y `cryptsetup`, el dispositivo descifrado en
`/dev/mapper`, `/etc/crypttab`, y qué protege (y qué no) el cifrado en reposo.

Herramientas útiles: `cryptsetup`, `lsblk -f`, `blkid`, `mkfs.ext4`, `findmnt`, `systemctl daemon-reload`.

`lab console srv` · `lab check` · `lab hint`
