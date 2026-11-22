# Un PC de empleado con SSH abierto (como tantos): nadie de fuera de la LAN debería poder llegar.
cat > /usr/local/bin/banner.sh <<'EOF'
#!/bin/sh
printf 'SSH-2.0-OpenSSH_9.6 pc-de-empleado\r\n'
EOF
chmod +x /usr/local/bin/banner.sh
pkill socat 2>/dev/null
setsid socat TCP4-LISTEN:22,fork,reuseaddr EXEC:/usr/local/bin/banner.sh </dev/null >/dev/null 2>&1 &
sleep 1
