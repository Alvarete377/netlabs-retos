# Una web cualquiera de Internet (para que el router pueda descargar algo de fuera).
cat > /usr/local/bin/web.sh <<'EOF'
#!/bin/sh
read -r _peticion
printf 'HTTP/1.0 200 OK\r\nContent-Type: text/plain\r\n\r\nactualizacion disponible\n'
EOF
chmod +x /usr/local/bin/web.sh
pkill socat 2>/dev/null
setsid socat TCP4-LISTEN:80,fork,reuseaddr EXEC:/usr/local/bin/web.sh </dev/null >/dev/null 2>&1 &
sleep 1
