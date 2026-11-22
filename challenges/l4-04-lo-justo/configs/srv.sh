# Servidor de la DMZ: web (80), SSH de administración (22) y base de datos (3306).
cat > /usr/local/bin/web.sh <<'EOF'
#!/bin/sh
read -r _peticion
printf 'HTTP/1.0 200 OK\r\nContent-Type: text/plain\r\n\r\nweb publica de la empresa\n'
EOF
cat > /usr/local/bin/banner.sh <<'EOF'
#!/bin/sh
printf '%s\r\n' "$BANNER"
EOF
chmod +x /usr/local/bin/web.sh /usr/local/bin/banner.sh
pkill socat 2>/dev/null
setsid socat TCP4-LISTEN:80,fork,reuseaddr EXEC:/usr/local/bin/web.sh </dev/null >/dev/null 2>&1 &
BANNER="SSH-2.0-OpenSSH_9.6 dmz" setsid socat TCP4-LISTEN:22,fork,reuseaddr EXEC:/usr/local/bin/banner.sh </dev/null >/dev/null 2>&1 &
BANNER="mysql 8.0 dmz" setsid socat TCP4-LISTEN:3306,fork,reuseaddr EXEC:/usr/local/bin/banner.sh </dev/null >/dev/null 2>&1 &
sleep 1
