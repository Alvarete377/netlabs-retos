# RAID 1 (md0) con vdb + vdc, montado en /srv/contabilidad. Luego "muere" vdc: sale del RAID y queda
# inservible (sin superbloque y marcado). vdd es el disco nuevo que ha puesto el técnico.
set -e
mdadm --create /dev/md0 --level=1 --raid-devices=2 --metadata=1.2 --run --quiet /dev/vdb /dev/vdc
mdadm --wait /dev/md0 || true
mkfs.ext4 -q -L CONTABILIDAD /dev/md0
mkdir -p /srv/contabilidad
echo "/dev/md0 /srv/contabilidad ext4 defaults 0 2" >> /etc/fstab
mdadm --detail --scan > /etc/mdadm/mdadm.conf
systemctl daemon-reload
mount /srv/contabilidad
yes "asiento contable" | head -c 52428800 > /srv/contabilidad/libro-mayor.dat
sync
mdadm /dev/md0 --fail /dev/vdc --remove /dev/vdc
mdadm --zero-superblock /dev/vdc
# El disco averiado: ni particiones ni sistema de ficheros; "lo ha marcado" el técnico.
echo "DISCO AVERIADO - NO USAR" | dd of=/dev/vdc bs=512 seek=1 conv=notrunc status=none
