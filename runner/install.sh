#!/usr/bin/env bash
# Prepara un host Linux (WSL2 Ubuntu 24.04 o la VM del .ova) para NetLabs.
# Uso (como root):  NETLABS_USER=<usuario> bash runner/install.sh
set -euo pipefail

REPO="$(cd "$(dirname "$0")/.." && pwd)"
U="${NETLABS_USER:-${SUDO_USER:-}}"
[ "$(id -u)" -eq 0 ] || { echo "Ejecuta este script como root."; exit 1; }
[ -n "$U" ] && id "$U" >/dev/null 2>&1 || { echo "Define NETLABS_USER con tu usuario Linux."; exit 1; }
UHOME="$(getent passwd "$U" | cut -d: -f6)"

echo "[1/7] KVM"
[ -e /dev/kvm ] || { echo "ERROR: no hay /dev/kvm. En Windows pon nestedVirtualization=true en %UserProfile%\.wslconfig y ejecuta 'wsl --shutdown'."; exit 1; }

echo "[2/7] systemd"
if grep -qi microsoft /proc/version && [ "$(ps -p 1 -o comm=)" != "systemd" ]; then
  [ -f /etc/wsl.conf ] && cp /etc/wsl.conf /etc/wsl.conf.bak
  if ! grep -Eq '^[[:space:]]*systemd[[:space:]]*=[[:space:]]*true' /etc/wsl.conf 2>/dev/null; then
    sed -i '/^[[:space:]]*systemd[[:space:]]*=/d' /etc/wsl.conf 2>/dev/null || true
    if grep -q '^\[boot\]' /etc/wsl.conf 2>/dev/null; then
      sed -i '/^\[boot\]/a systemd=true' /etc/wsl.conf
    else
      printf '\n[boot]\nsystemd=true\n' >> /etc/wsl.conf
    fi
  fi
  echo "systemd activado en /etc/wsl.conf. Ejecuta 'wsl --shutdown' en Windows y vuelve a lanzar este script."
  exit 1
fi

echo "[3/7] Paquetes"
apt-get update -qq
DEBIAN_FRONTEND=noninteractive apt-get install -y -qq ca-certificates curl git make unzip sshpass python3-venv python3-pip >/dev/null

echo "[4/7] Docker"
if command -v docker >/dev/null && readlink -f "$(command -v docker)" | grep -q docker-desktop; then
  echo "ERROR: el comando docker es el de Docker Desktop. Desactiva la integración WSL de Docker Desktop para esta distro."; exit 1
fi
if ! systemctl is-active --quiet docker; then
  curl -fsSL https://get.docker.com | sh
  systemctl enable --now docker
fi
usermod -aG docker,kvm "$U"

echo "[5/7] containerlab"
command -v containerlab >/dev/null || SUDO_USER="$U" bash -c "$(curl -fsSL https://get.containerlab.dev)"
getent group clab_admins >/dev/null && usermod -aG clab_admins "$U"
CLAB="$(command -v containerlab)" || { echo "ERROR: containerlab no se instaló"; exit 1; }
SUDOERS_TMP="$(mktemp)"
echo "$U ALL=(root) NOPASSWD: $CLAB" > "$SUDOERS_TMP"
visudo -cf "$SUDOERS_TMP" >/dev/null || { rm -f "$SUDOERS_TMP"; echo "ERROR: la línea de sudoers no es válida"; exit 1; }
install -m 440 "$SUDOERS_TMP" /etc/sudoers.d/netlabs
rm -f "$SUDOERS_TMP"

echo "[6/7] Imágenes"
if [ -x "$REPO/images/build.sh" ]; then "$REPO/images/build.sh"; else echo "(images/build.sh aún no existe, se omite)"; fi

echo "[7/7] CLI lab"
if [ -f "$REPO/cli/pyproject.toml" ]; then
  sudo -u "$U" python3 -m venv "$UHOME/.netlabs/venv"
  sudo -u "$U" "$UHOME/.netlabs/venv/bin/pip" install -q -e "$REPO/cli[dev]"
  ln -sf "$UHOME/.netlabs/venv/bin/lab" /usr/local/bin/lab
else
  echo "(cli/ aún no existe, se omite)"
fi

echo "Listo. Abre una terminal nueva de WSL para que se apliquen los grupos docker/kvm."
