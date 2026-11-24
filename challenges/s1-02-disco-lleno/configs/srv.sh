mkdir -p /srv/datos
mount -t tmpfs -o size=64m tmpfs /srv/datos
python3 -c 'import sys; sys.stdout.write("".join(f"{i};cliente{i};{(i * 7919) % 90000 + 10000}\n" for i in range(2000)))' > /srv/datos/clientes.db
i=1; while [ $i -le 500 ]; do echo "2024-12-01 00:00:$i factura emitida (histórico)"; i=$((i+1)); done > /srv/datos/facturas.log
# Rellena hasta el final de la página de memoria: así, con el disco lleno, la siguiente línea ya no cabe.
pad=$(( (4096 - $(stat -c %s /srv/datos/facturas.log) % 4096) % 4096 ))
if [ $pad -gt 1 ]; then head -c $((pad - 1)) /dev/zero | tr '\0' '#' >> /srv/datos/facturas.log; fi
if [ $pad -gt 0 ]; then echo >> /srv/datos/facturas.log; fi
head -c 30M /dev/urandom > /srv/datos/copia-2023.tar

cat > /usr/local/bin/facturas <<'EOF'
#!/bin/sh
# Emite una factura por segundo. Si no puede escribir, se para.
while true; do
  echo "$(date '+%F %T') factura emitida" >> /srv/datos/facturas.log || exit 1
  sleep 1
done
EOF
cat > /usr/local/bin/exportador <<'EOF'
#!/bin/sh
# Exportación nocturna que se quedó colgada: abrió su temporal, lo borró y nunca lo cerró.
exec 3>/srv/datos/export.tmp
head -c 64M /dev/zero >&3 2>/dev/null
rm -f /srv/datos/export.tmp
exec sleep infinity
EOF
chmod +x /usr/local/bin/facturas /usr/local/bin/exportador
cat > /etc/systemd/system/facturas.service <<'EOF'
[Unit]
Description=Emisión de facturas
[Service]
ExecStart=/usr/local/bin/facturas
[Install]
WantedBy=multi-user.target
EOF
cat > /etc/systemd/system/exportador.service <<'EOF'
[Unit]
Description=Exportación de datos
[Service]
ExecStart=/usr/local/bin/exportador
Restart=on-failure
RestartSec=3
[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl enable -q facturas exportador
systemctl start exportador
i=0; while [ $i -lt 40 ] && [ "$(df --output=avail /srv/datos | tail -1)" -gt 64 ]; do sleep 0.5; i=$((i+1)); done
systemctl start facturas || true
sleep 2
