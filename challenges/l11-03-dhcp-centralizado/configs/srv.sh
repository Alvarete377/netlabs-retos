# Servidor web de la intranet (puerto 80).
ip route del default dev eth0 2>/dev/null || true
cat > /usr/local/bin/web.sh <<'EOF'
#!/bin/sh
read -r _peticion
printf 'HTTP/1.0 200 OK\r\nContent-Type: text/plain\r\n\r\nintranet de la empresa\n'
EOF
chmod +x /usr/local/bin/web.sh
pkill socat 2>/dev/null
setsid socat TCP4-LISTEN:80,fork,reuseaddr EXEC:/usr/local/bin/web.sh </dev/null >/dev/null 2>&1 &
sleep 1
