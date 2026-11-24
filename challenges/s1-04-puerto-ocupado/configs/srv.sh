mkdir -p /opt/panel-viejo
echo '<h1>Panel de administración (2019). Fuera de servicio.</h1>' > /opt/panel-viejo/index.html
printf '%s\n' '<!doctype html><title>Intranet</title><h1>Intranet de Ferretería López</h1><p>Servida por nginx.</p>' > /var/www/html/index.html
cat > /etc/systemd/system/panel-viejo.service <<'EOF'
[Unit]
Description=Panel de administración antiguo
After=network.target
[Service]
ExecStart=/usr/bin/python3 -m http.server 80 --directory /opt/panel-viejo
Restart=always
RestartSec=2
[Install]
WantedBy=multi-user.target
EOF
systemctl stop nginx
systemctl daemon-reload
systemctl enable -q --now panel-viejo
sleep 1
systemctl restart nginx 2>/dev/null || true
