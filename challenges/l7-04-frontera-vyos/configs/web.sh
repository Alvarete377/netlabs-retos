# Servidor web de la empresa (80) con SSH de administración (22), en la DMZ.
cat > /usr/local/bin/http.sh <<'EOF'
#!/bin/sh
read -r _peticion
printf 'HTTP/1.0 200 OK\r\nContent-Type: text/plain\r\n\r\nweb de la empresa\n'
EOF
cat > /usr/local/bin/ssh.sh <<'EOF'
#!/bin/sh
printf 'SSH-2.0-OpenSSH_9.6 web-dmz\r\n'
EOF
chmod +x /usr/local/bin/http.sh /usr/local/bin/ssh.sh
pkill socat 2>/dev/null
setsid socat TCP4-LISTEN:80,fork,reuseaddr EXEC:/usr/local/bin/http.sh </dev/null >/dev/null 2>&1 &
setsid socat TCP4-LISTEN:22,fork,reuseaddr EXEC:/usr/local/bin/ssh.sh </dev/null >/dev/null 2>&1 &
sleep 1
