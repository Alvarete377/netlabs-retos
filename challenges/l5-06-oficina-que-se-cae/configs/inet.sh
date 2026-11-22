# Web de Internet en 203.0.113.10 (alcanzable por los dos proveedores).
cat > /usr/local/bin/web.sh <<'EOS'
#!/bin/sh
read -r _peticion
printf 'HTTP/1.0 200 OK\r\nContent-Type: text/plain\r\n\r\nservidor de Internet\ncliente=%s\n' "$SOCAT_PEERADDR"
EOS
chmod +x /usr/local/bin/web.sh
ip route del default dev eth0 2>/dev/null
pkill socat 2>/dev/null
setsid socat TCP4-LISTEN:80,fork,reuseaddr EXEC:/usr/local/bin/web.sh </dev/null >/dev/null 2>&1 &
sleep 1
