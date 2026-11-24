cat > /usr/local/bin/copia-web <<'EOF'
#!/bin/sh
# Copia de la web: un .tar.gz por día en /var/backups/web.
set -e
mkdir -p /var/backups/web
tar -czf /var/backups/web/web-$(date +%F).tar.gz -C /var/www html
echo "copia hecha: $(ls /var/backups/web | wc -l) ficheros"
EOF
chmod +x /usr/local/bin/copia-web
echo '30 2 * * * root /usr/local/bin/copia-web >/dev/null 2>&1' > /etc/cron.d/copia-web
