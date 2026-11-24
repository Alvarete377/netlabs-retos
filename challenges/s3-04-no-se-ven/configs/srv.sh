systemctl start netlabs-imagenes
mkdir -p /srv/datos /srv/api
echo 'estado: OK' > /srv/datos/estado.txt
cat > /srv/api/arranque.sh <<'EOF'
#!/bin/sh
# Cada 3 s pregunta a "datos" por su estado y lo publica en su web (nginx).
W=/usr/share/nginx/html/index.html
while true; do
  if r=$(wget -qO- -T2 http://datos/estado.txt 2>/dev/null); then
    echo "$r" > $W
  else
    echo "estado: SIN CONEXION CON datos" > $W
  fi
  sleep 3
done &
exec nginx -g 'daemon off;'
EOF
podman run -d -q --name datos -p 8083:80 -v /srv/datos:/usr/share/nginx/html:ro nginx:1.27-alpine >/dev/null
podman run -d -q --name api -p 8082:80 -v /srv/api/arranque.sh:/arranque.sh:ro nginx:1.27-alpine sh /arranque.sh >/dev/null
