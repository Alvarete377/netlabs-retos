# Puesto con IPv6 únicamente: se configura solo con los anuncios del router (SLAAC).
ip -6 route del default dev eth0 2>/dev/null || true
# Un servicio cualquiera en el 22, para comprobar que desde fuera no se llega.
cat > /usr/local/bin/ssh.sh <<'EOF'
#!/bin/sh
printf 'SSH-2.0-OpenSSH_9.6\r\n'
EOF
chmod +x /usr/local/bin/ssh.sh
pkill socat 2>/dev/null
setsid socat TCP6-LISTEN:22,fork,reuseaddr EXEC:/usr/local/bin/ssh.sh </dev/null >/dev/null 2>&1 &
sleep 1
