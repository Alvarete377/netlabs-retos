#!/bin/bash
# Construye netlabs/debian-vm:0.1 (Debian 12 como máquina virtual en un contenedor). Necesita /dev/kvm.
# Uso: bash images/debian-vm/build.sh   (lo llama images/build.sh)
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
DOCKER="${DOCKER:-docker}"
IMG="debian-12-genericcloud-amd64.qcow2"
URL="https://cloud.debian.org/images/cloud/bookworm/latest/$IMG"

if $DOCKER image inspect netlabs/debian-vm:0.1 >/dev/null 2>&1; then
  echo "netlabs/debian-vm:0.1 ya existe"; exit 0
fi
[ -e /dev/kvm ] || { echo "ERROR: no hay /dev/kvm (activa la virtualización anidada)"; exit 1; }

mkdir -p "$HERE/cache"
if [ ! -f "$HERE/cache/$IMG" ]; then
  echo "Descargando la imagen cloud de Debian 12..."
  curl -fL --retry 3 -o "$HERE/cache/$IMG.part" "$URL"
  mv "$HERE/cache/$IMG.part" "$HERE/cache/$IMG"
fi

if [ ! -f "$HERE/cache/netlabs.qcow2" ]; then
  $DOCKER build -q -t netlabs/debian-vm-custom:0.1 -f "$HERE/Dockerfile.custom" "$HERE"
  $DOCKER run --rm --device /dev/kvm -v "$HERE:/w" netlabs/debian-vm-custom:0.1 bash /w/bake.sh
  $DOCKER rmi netlabs/debian-vm-custom:0.1 >/dev/null 2>&1 || true
fi
$DOCKER build -q -t netlabs/debian-vm-base:0.1 -f "$HERE/Dockerfile.base" "$HERE"
$DOCKER build -q -t netlabs/debian-vm:0.1 "$HERE"
echo "OK: netlabs/debian-vm:0.1"
