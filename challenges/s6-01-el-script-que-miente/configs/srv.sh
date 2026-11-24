mkdir -p /srv/app/logs
cat > /usr/local/bin/limpiar-logs <<'EOF'
#!/bin/sh
# Borra los .log de más de 7 días.
DIR=/srv/app/logs
for f in $(find $DIR -name "*.log" -mtime +7); do
  rm $f
done
echo "limpieza hecha"
EOF
chmod 755 /usr/local/bin/limpiar-logs
