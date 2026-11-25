# Disco de datos con dos particiones montadas por fstab. Luego: el disco de datos se "restauró de una
# copia" (su sistema de ficheros tiene otro UUID) y alguien escribió mal una opción. Se reinicia y el
# servidor ya no arranca: modo de emergencia. La contraseña de root (para la emergencia) es netlabs.
set -e
parted -s /dev/vdb mklabel gpt mkpart datos ext4 1MiB 60% mkpart copias ext4 60% 100%
udevadm settle
mkfs.ext4 -q -L DATOS /dev/vdb1
mkfs.ext4 -q -L COPIAS /dev/vdb2
mkdir -p /datos /copias
mount /dev/vdb1 /datos
echo "presupuesto 2027" > /datos/presupuesto.txt
umount /datos
OLD=$(blkid -s UUID -o value /dev/vdb1)
cat >> /etc/fstab <<EOF
UUID=$OLD /datos ext4 defaults,x-systemd.device-timeout=15s 0 2
UUID=$(blkid -s UUID -o value /dev/vdb2) /copias ext4 defualts,noatime 0 2
EOF
tune2fs -U random /dev/vdb1 >/dev/null
echo root:netlabs | chpasswd
systemd-run --quiet --on-active=2 systemctl reboot
