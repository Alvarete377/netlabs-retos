systemctl start netlabs-imagenes
mkdir -p /srv/informes/www
echo 'Informe diario: OK' > /srv/informes/www/index.html
cat > /srv/informes/arranque.sh <<'EOF'
#!/bin/sh
# Carga en memoria la caché de informes (unos 40 MB) y sirve la web con nginx.
echo "Cargando caché de informes..."
CACHE=$(head -c 40000000 /dev/zero | tr '\0' x)
echo "Caché lista (${#CACHE} bytes)"
nginx
while true; do sleep 3600; done
EOF
podman run -d -q --name informes --memory 16m -p 8081:80 -v /srv/informes/www:/usr/share/nginx/html:ro \
  -v /srv/informes/arranque.sh:/arranque.sh:ro nginx:1.27-alpine sh /arranque.sh >/dev/null
