#!/usr/bin/env bash
# Construye las imágenes base de NetLabs. Idempotente.
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
CHR_VERSION="${CHR_VERSION:-7.16.2}"
DOCKER=docker; docker info >/dev/null 2>&1 || DOCKER="sudo docker"

# 0.2 añade openssl y ca-certificates (módulo TLS); 0.1 queda como alias de la misma imagen.
echo "== netlabs/client:0.2"
$DOCKER build -q -t netlabs/client:0.2 -t netlabs/client:0.1 "$HERE/client"

# Servidor Debian con systemd para los retos de Sistemas (y Monitorización).
echo "== netlabs/debian:0.1"
$DOCKER build -q -t netlabs/debian:0.1 "$HERE/debian"

echo "== netlabs/chr:$CHR_VERSION"
if $DOCKER image inspect "netlabs/chr:$CHR_VERSION" >/dev/null 2>&1; then
  echo "ya existe"; exit 0
fi
WORK="$(mktemp -d)"; trap 'rm -rf "$WORK"' EXIT
git clone -q --depth 1 https://github.com/srl-labs/vrnetlab "$WORK/vrnetlab"
DIR=""
for d in mikrotik/routeros routeros; do
  if [ -d "$WORK/vrnetlab/$d" ]; then DIR="$WORK/vrnetlab/$d"; break; fi
done
[ -n "$DIR" ] || { echo "ERROR: no encuentro el directorio de routeros en vrnetlab"; exit 1; }
curl -fsSL -o "$WORK/chr.zip" "https://download.mikrotik.com/routeros/$CHR_VERSION/chr-$CHR_VERSION.vmdk.zip"
unzip -q -o "$WORK/chr.zip" -d "$DIR"
(cd "$DIR" && make docker-image)
BUILT="$($DOCKER images --format '{{.Repository}}:{{.Tag}}' | grep -i routeros | grep -F "$CHR_VERSION" | head -1)"
[ -n "$BUILT" ] || { echo "ERROR: vrnetlab no generó la imagen"; exit 1; }
$DOCKER tag "$BUILT" "netlabs/chr:$CHR_VERSION"
echo "OK: $BUILT -> netlabs/chr:$CHR_VERSION"
