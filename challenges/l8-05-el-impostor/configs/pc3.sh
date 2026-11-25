# pc3: equipo nuevo instalado clonando la configuración de pc1 (misma IP). Como muchos NAS y
# teléfonos IP, se anuncia por ARP cada pocos segundos mientras tenga esa dirección.
ip route del default dev eth0 2>/dev/null
cat > /usr/local/bin/anuncio.sh <<'EOF'
#!/bin/sh
while :; do
  if ip -4 addr show dev eth1 | grep -q ' 192\.168\.1\.10/'; then
    arping -q -U -c 1 -I eth1 192.168.1.10
    ping -q -c 1 -W 1 -I eth1 192.168.20.10 >/dev/null 2>&1
  fi
  sleep 2
done
EOF
chmod +x /usr/local/bin/anuncio.sh
pkill -f anuncio.sh 2>/dev/null
setsid /usr/local/bin/anuncio.sh </dev/null >/dev/null 2>&1 &
sleep 1
