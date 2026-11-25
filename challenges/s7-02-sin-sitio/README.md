# Se queda sin sitio

```
 srv (máquina virtual Debian 12)
   vdb 1 GB ─ PV ─┐
                  ├─ VG «datos» ─ LV «web» 400 MB ─ ext4 ─ /srv/web  (casi lleno)
   vdc 1 GB ─ (nuevo, sin usar)
```

La web de la tienda vive en `/srv/web`, un volumen lógico **LVM** de 400 MB que está casi lleno. Para la
campaña de Navidad necesita **al menos 1,5 GB**. Ya han conectado un segundo disco (`/dev/vdc`). La
tienda no puede pararse: nada de apagar el servidor ni desmontar `/srv/web`.

**Objetivos:**

1. Mete el disco nuevo en el grupo de volúmenes `datos`.
2. Amplía el volumen lógico `datos/web` hasta al menos 1,5 GB **en caliente**.
3. Que el sistema de ficheros crezca también (que `df -h /srv/web` vea el espacio).
4. Sin perder nada de lo que hay en `/srv/web`.

**Qué aprendes:** las tres capas de LVM (PV → VG → LV), ampliar sin parar el servicio y la diferencia
entre ampliar el volumen y ampliar el sistema de ficheros.

Herramientas útiles: `lsblk`, `pvs`, `vgs`, `lvs`, `pvcreate`, `vgextend`, `lvextend`, `resize2fs`, `df -h`.

`lab console srv` · `lab check` · `lab hint`
