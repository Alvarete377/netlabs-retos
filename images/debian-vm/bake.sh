#!/bin/bash
# Prepara el disco de netlabs/debian-vm a partir de la imagen cloud oficial de Debian 12, sin
# arrancarla (virt-customize): paquetes, clave SSH del laboratorio, consola serie con autologin, GRUB
# visible por la serie, interfaces ethN y fuera cloud-init (arranques rápidos y deterministas).
# Se ejecuta dentro de netlabs/debian-vm-custom con /dev/kvm y este directorio montado en /w.
set -euo pipefail
cd /w/cache
[ -f key ] || ssh-keygen -q -t ed25519 -N '' -C netlabs-lab -f key
cp debian-12-genericcloud-amd64.qcow2 bake.qcow2

cat > autologin.conf <<'EOF'
[Service]
ExecStart=
ExecStart=-/sbin/agetty --autologin root --keep-baud 115200,57600,38400,9600 %I $TERM
EOF
cat > grub-netlabs.cfg <<'EOF'
GRUB_CMDLINE_LINUX_DEFAULT="net.ifnames=0 biosdevname=0"
GRUB_TIMEOUT=3
GRUB_TIMEOUT_STYLE=menu
GRUB_TERMINAL="serial console"
GRUB_SERIAL_COMMAND="serial --speed=115200"
EOF
cat > netplan-gestion.yaml <<'EOF'
# Red de gestión del laboratorio (no la toques: la usa `lab` para entrar por SSH).
network:
  version: 2
  ethernets:
    eth0:
      dhcp4: true
EOF
cat > motd <<'EOF'
NetLabs · Sistemas. Estás dentro de una MÁQUINA VIRTUAL Debian del laboratorio
(kernel, discos y arranque propios). eth0 es la gestión del laboratorio: no la toques.
EOF

virt-customize -a bake.qcow2 --network --smp 2 --memsize 1024 \
  --run-command 'echo "APT::Install-Recommends \"false\";" > /etc/apt/apt.conf.d/99netlabs-norecommends' \
  --install lvm2,mdadm,parted,gdisk,xfsprogs,dosfstools,cryptsetup,quota,nftables,tcpdump,curl,vim,nano,less,lsof,psmisc,htop,rsync,file,tree,bash-completion,man-db,netcat-openbsd,socat,dnsutils,iputils-ping,traceroute \
  --uninstall cloud-init \
  --run-command 'ssh-keygen -A' \
  --ssh-inject root:file:/w/cache/key.pub \
  --mkdir /etc/systemd/system/serial-getty@ttyS0.service.d \
  --upload autologin.conf:/etc/systemd/system/serial-getty@ttyS0.service.d/autologin.conf \
  --upload grub-netlabs.cfg:/etc/default/grub.d/99-netlabs.cfg \
  --upload netplan-gestion.yaml:/etc/netplan/01-netlabs-gestion.yaml \
  --chmod 0600:/etc/netplan/01-netlabs-gestion.yaml \
  --upload motd:/etc/motd \
  --run-command 'update-grub' \
  --run-command 'echo "PS1=\"\\[\\e[1;32m\\]\\u@\\h\\[\\e[0m\\]:\\[\\e[1;34m\\]\\w\\[\\e[0m\\]\\\$ \"" >> /root/.bashrc' \
  --hostname debian \
  --run-command 'apt-get clean' \
  --run-command 'systemctl disable apt-daily.timer apt-daily-upgrade.timer man-db.timer || true'

qemu-img convert -c -O qcow2 bake.qcow2 netlabs.qcow2
rm -f bake.qcow2 autologin.conf grub-netlabs.cfg netplan-gestion.yaml motd
ls -lh netlabs.qcow2
