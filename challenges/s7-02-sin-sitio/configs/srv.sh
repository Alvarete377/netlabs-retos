# Volumen LVM de la web: 400 MB en el VG "datos" (sólo vdb). vdc es el disco nuevo, sin usar.
set -e
pvcreate -q /dev/vdb
vgcreate -q datos /dev/vdb
lvcreate -q -y -L 400M -n web datos
mkfs.ext4 -q -L WEB /dev/datos/web
mkdir -p /srv/web
echo "/dev/datos/web /srv/web ext4 defaults 0 2" >> /etc/fstab
systemctl daemon-reload
mount /srv/web
yes NetLabs | head -c 314572800 > /srv/web/contenido.bin
echo "Catálogo de la tienda: NO BORRAR" > /srv/web/LEEME.txt
sync
