# Servidor Debian 12 como MÁQUINA VIRTUAL dentro de un contenedor (como hace vrnetlab con el CHR).
# A diferencia de netlabs/debian (contenedor), tiene kernel, disco y arranque propios: GRUB,
# initramfs, fstab, LVM, RAID, módulos del kernel... Necesita /dev/kvm (WSL2 lo tiene).
#
# Variables de entorno (en `env:` del nodo en la topología):
#   VM_RAM (MB, 512)  VM_CPUS (1)  EXTRA_DISKS (0)  EXTRA_DISK_SIZE (1G)
FROM netlabs/debian-vm-base:0.1
COPY cache/netlabs.qcow2 /vm/base.qcow2
COPY cache/key /vm/key
COPY launch.sh vmexec /usr/local/bin/
RUN chmod 600 /vm/key && chmod +x /usr/local/bin/launch.sh /usr/local/bin/vmexec
HEALTHCHECK --interval=5s --timeout=8s --start-period=15s --retries=3 CMD vmexec true
CMD ["/usr/local/bin/launch.sh"]
