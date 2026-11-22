# Servidor de la oficina: web en el 80 (dice desde qué IP le llega cada conexión) y un SSH de
# administración en el 22 que NO debe verse desde Internet.
cat > /usr/local/bin/web.sh <<'EOF'
#!/bin/sh
read -r _peticion
printf 'HTTP/1.0 200 OK\r\nContent-Type: text/plain\r\n\r\nweb de la oficina\ncliente=%s\n' "$SOCAT_PEERADDR"
EOF
cat > /usr/local/bin/ssh.sh <<'EOF'
#!/bin/sh
printf 'SSH-2.0-OpenSSH_9.6 servidor-interno\r\n'
EOF
chmod +x /usr/local/bin/web.sh /usr/local/bin/ssh.sh
pkill socat 2>/dev/null
setsid socat TCP4-LISTEN:80,fork,reuseaddr EXEC:/usr/local/bin/web.sh </dev/null >/dev/null 2>&1 &
setsid socat TCP4-LISTEN:22,fork,reuseaddr EXEC:/usr/local/bin/ssh.sh </dev/null >/dev/null 2>&1 &
sleep 1
