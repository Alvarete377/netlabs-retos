# Servidor web (IPv6) en 2001:db8:20::10, puerto 80.
ip -6 route del default dev eth0 2>/dev/null || true
cat > /usr/local/bin/web.sh <<'EOF'
#!/bin/sh
read -r _peticion
printf 'HTTP/1.0 200 OK\r\nContent-Type: text/plain\r\n\r\nservidor web por IPv6\n'
EOF
chmod +x /usr/local/bin/web.sh
pkill socat 2>/dev/null
setsid socat TCP6-LISTEN:80,fork,reuseaddr EXEC:/usr/local/bin/web.sh </dev/null >/dev/null 2>&1 &
sleep 1
