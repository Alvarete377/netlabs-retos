# PC de contabilidad: su aplicación antigua entra cada pocos segundos en el servidor por telnet.
cat > /usr/local/bin/app-contable.sh <<'EOF'
#!/bin/sh
while true; do
  printf 'contabilidad\r\nVerano2026!\r\n' | nc -w 2 192.168.20.10 23 >/dev/null 2>&1
  sleep 4
done
EOF
chmod +x /usr/local/bin/app-contable.sh
ip route del default dev eth0 2>/dev/null
pkill -f app-contable 2>/dev/null
setsid /usr/local/bin/app-contable.sh </dev/null >/dev/null 2>&1 &
