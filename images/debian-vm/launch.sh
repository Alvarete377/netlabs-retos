#!/bin/bash
# Arranca la máquina virtual Debian. Cada interfaz de datos del contenedor (eth1, eth2...) se une a
# una tap de QEMU con tc mirred (transparente: pasan ARP, VLAN, LACP...). eth0 de la VM es la red de
# usuario de QEMU, sólo para gestión (SSH en 127.0.0.1:2222 del contenedor).
set -e

# containerlab conecta las interfaces después de arrancar el contenedor: esperamos a que estén.
if [ -n "$CLAB_INTFS" ]; then
  n=$CLAB_INTFS
  for i in $(seq 1 "$n"); do
    until ip link show "eth$i" >/dev/null 2>&1; do sleep 0.5; done
  done
else
  sleep 5
  n=$(ls /sys/class/net | grep -cE '^eth[1-9][0-9]*$' || true)
fi

cd /vm
rm -f disk.qcow2 extra*.qcow2
qemu-img create -q -f qcow2 -F qcow2 -b /vm/base.qcow2 disk.qcow2
disks=(-drive "file=disk.qcow2,if=virtio,cache=unsafe,discard=unmap")
for d in $(seq 1 "${EXTRA_DISKS:-0}"); do
  qemu-img create -q -f qcow2 "extra$d.qcow2" "${EXTRA_DISK_SIZE:-1G}"
  disks+=(-drive "file=extra$d.qcow2,if=virtio,cache=unsafe,discard=unmap")
done

nics=(-netdev "user,id=mgmt,hostfwd=tcp:127.0.0.1:2222-:22"
      -device "virtio-net-pci,netdev=mgmt,mac=52:54:00:4e:00:00")
for i in $(seq 1 "$n"); do
  ip tuntap add "tap$i" mode tap
  ip link set "tap$i" up
  ip link set "eth$i" up promisc on
  tc qdisc add dev "eth$i" ingress
  tc filter add dev "eth$i" parent ffff: protocol all u32 match u8 0 0 action mirred egress redirect dev "tap$i"
  tc qdisc add dev "tap$i" ingress
  tc filter add dev "tap$i" parent ffff: protocol all u32 match u8 0 0 action mirred egress redirect dev "eth$i"
  nics+=(-netdev "tap,id=n$i,ifname=tap$i,script=no,downscript=no"
         -device "virtio-net-pci,netdev=n$i,mac=52:54:00:4e:00:$(printf %02x "$i")")
done

exec qemu-system-x86_64 -enable-kvm -cpu host -machine q35 \
  -m "${VM_RAM:-512}" -smp "${VM_CPUS:-1}" \
  -display none -monitor none -serial telnet:127.0.0.1:5000,server,nowait \
  "${disks[@]}" "${nics[@]}"
