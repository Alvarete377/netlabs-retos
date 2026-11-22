# Servidor web de "Internet": responde diciendo desde qué IP le llega cada conexión.
cat > /usr/local/bin/web.sh <<'EOF'
#!/bin/sh
read -r _peticion
printf 'HTTP/1.0 200 OK\r\nContent-Type: text/plain\r\n\r\nservidor de Internet\ncliente=%s\n' "$SOCAT_PEERADDR"
EOF
chmod +x /usr/local/bin/web.sh
pkill socat 2>/dev/null
setsid socat TCP4-LISTEN:80,fork,reuseaddr EXEC:/usr/local/bin/web.sh </dev/null >/dev/null 2>&1 &
sleep 1
