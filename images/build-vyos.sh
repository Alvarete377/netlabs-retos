#!/usr/bin/env bash
# Construye netlabs/vyos:rolling (módulo Multifabricante) a partir de la ISO pública "rolling" de VyOS.
# No necesita sudo: la ISO se desempaqueta dentro de un contenedor Alpine. Descarga ~650 MB.
# Uso: bash images/build-vyos.sh [version]   (por defecto, la última rolling publicada)
set -euo pipefail
DOCKER=docker; docker info >/dev/null 2>&1 || DOCKER="sudo docker"
if $DOCKER image inspect netlabs/vyos:rolling >/dev/null 2>&1 && [ "${1:-}" = "" ]; then
  echo "netlabs/vyos:rolling ya existe (pasa una versión para reconstruir)"; exit 0
fi
VER="${1:-$(curl -fsSL https://api.github.com/repos/vyos/vyos-nightly-build/releases/latest | python3 -c 'import sys,json; print(json.load(sys.stdin)["tag_name"])')}"
URL="https://github.com/vyos/vyos-nightly-build/releases/download/${VER}/vyos-${VER}-generic-amd64.iso"
W="$(mktemp -d)"; trap '$DOCKER run --rm -v "$W:/w" alpine:3.20 rm -rf /w/iso /w/rootfs >/dev/null 2>&1; rm -rf "$W"' EXIT
echo "== VyOS ${VER}: descargando ISO (~650 MB)"
curl -fL --retry 3 -o "$W/vyos.iso" "$URL"
echo "== desempaquetando y creando la imagen"
$DOCKER run --rm -v "$W:/w" alpine:3.20 sh -c '
  set -e
  apk add --no-cache squashfs-tools libarchive-tools >/dev/null
  mkdir -p /w/iso
  bsdtar -xf /w/vyos.iso -C /w/iso live/filesystem.squashfs
  unsquashfs -q -d /w/rootfs /w/iso/live/filesystem.squashfs >/dev/null
  tar -C /w/rootfs -c .
' | $DOCKER import --change 'CMD ["/sbin/init"]' - "netlabs/vyos:${VER}"
$DOCKER tag "netlabs/vyos:${VER}" netlabs/vyos:rolling
echo "OK: netlabs/vyos:rolling (${VER})"
