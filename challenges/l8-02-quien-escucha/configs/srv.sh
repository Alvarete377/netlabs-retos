# Servidor de la empresa: SSH (22), correo (25), panel web de administración (8181) y base de datos (3306).
cat > /usr/local/bin/ssh.sh <<'EOF'
#!/bin/sh
printf 'SSH-2.0-OpenSSH_9.6\r\n'
EOF
cat > /usr/local/bin/smtp.sh <<'EOF'
#!/bin/sh
printf '220 correo.empresa.lan ESMTP Postfix 3.9.1\r\n'
read -r _l
printf '221 Bye\r\n'
EOF
cat > /usr/local/bin/panel.sh <<'EOF'
#!/bin/sh
read -r _peticion
printf 'HTTP/1.0 200 OK\r\nContent-Type: text/plain\r\n\r\npanel de administracion de la empresa\n'
EOF
cat > /usr/local/bin/db.sh <<'EOF'
#!/bin/sh
printf '8.0.36 MySQL Community Server\n'
EOF
chmod +x /usr/local/bin/ssh.sh /usr/local/bin/smtp.sh /usr/local/bin/panel.sh /usr/local/bin/db.sh
ip route del default dev eth0 2>/dev/null
pkill socat 2>/dev/null
setsid socat TCP4-LISTEN:22,fork,reuseaddr EXEC:/usr/local/bin/ssh.sh </dev/null >/dev/null 2>&1 &
setsid socat TCP4-LISTEN:25,fork,reuseaddr EXEC:/usr/local/bin/smtp.sh </dev/null >/dev/null 2>&1 &
setsid socat TCP4-LISTEN:8181,fork,reuseaddr EXEC:/usr/local/bin/panel.sh </dev/null >/dev/null 2>&1 &
setsid socat TCP4-LISTEN:3306,fork,reuseaddr EXEC:/usr/local/bin/db.sh </dev/null >/dev/null 2>&1 &
sleep 1
