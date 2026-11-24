# Servidor antiguo: un servicio de acceso remoto tipo telnet (23) y SSH (22).
cat > /usr/local/bin/login.sh <<'EOF'
#!/bin/sh
printf 'servidor-contable login: '
read -r _u
printf 'Password: '
read -r _p
printf '\r\nBienvenido al sistema contable\r\n'
EOF
cat > /usr/local/bin/ssh.sh <<'EOF'
#!/bin/sh
printf 'SSH-2.0-OpenSSH_9.6\r\n'
EOF
chmod +x /usr/local/bin/login.sh /usr/local/bin/ssh.sh
ip route del default dev eth0 2>/dev/null
pkill socat 2>/dev/null
setsid socat TCP4-LISTEN:23,fork,reuseaddr EXEC:/usr/local/bin/login.sh </dev/null >/dev/null 2>&1 &
setsid socat TCP4-LISTEN:22,fork,reuseaddr EXEC:/usr/local/bin/ssh.sh </dev/null >/dev/null 2>&1 &
sleep 1
