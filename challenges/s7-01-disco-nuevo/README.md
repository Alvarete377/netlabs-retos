# Disco nuevo

```
 srv (máquina virtual Debian 12)
   vda  20 GB aprox. ─ sistema (no lo toques)
   vdb  1 GB        ─ disco NUEVO, vacío
```

Al servidor le acaban de añadir un disco de 1 GB para guardar datos. Está conectado pero vacío: sin
particiones ni sistema de ficheros.

**Objetivos:**

1. Tabla de particiones **GPT** en `/dev/vdb` con **una sola partición** que ocupe todo el disco.
2. Formatéala en **ext4** con la etiqueta **DATOS**.
3. Móntala en **/datos** de forma permanente: línea en `/etc/fstab` **por UUID**.
4. Comprueba que el fstab es correcto: `umount /datos && mount -a` la vuelve a montar.

**Qué aprendes:** discos de bloque y particiones en Linux, `parted`, `mkfs`, UUID y etiquetas, y por qué
el fstab se escribe con UUID.

> Este servidor es una **máquina virtual de verdad** (kernel y discos propios), no un contenedor. Entra
> con `lab console srv`; si algún día no arranca, `lab console srv --serie` te da la consola serie.

Herramientas útiles: `lsblk -f`, `parted`, `fdisk`, `mkfs.ext4`, `blkid`, `findmnt`, `mount -a`.

`lab console srv` · `lab check` · `lab hint`
