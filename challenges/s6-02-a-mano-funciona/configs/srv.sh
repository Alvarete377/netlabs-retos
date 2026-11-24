mkdir -p /opt/ventas/bin /var/informes/salida
cat > /opt/ventas/bin/informe-ventas <<'EOF'
#!/bin/sh
echo "Ventas del $(date +%F): 42 pedidos, 3.180 EUR"
EOF
chmod 755 /opt/ventas/bin/informe-ventas
echo 'export PATH="$PATH:/opt/ventas/bin"' >> /root/.bashrc
cat > /usr/local/bin/informe-diario <<'EOF'
#!/bin/bash
# Informe diario de ventas. Lo lanza cron a las 07:00.
informe-ventas > salida/informe-$(date +%F).txt
EOF
chmod 755 /usr/local/bin/informe-diario
echo '0 7 * * * root /usr/local/bin/informe-diario >/dev/null 2>&1' > /etc/cron.d/informe
