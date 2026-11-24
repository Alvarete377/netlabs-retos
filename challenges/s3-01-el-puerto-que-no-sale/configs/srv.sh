systemctl start netlabs-imagenes
mkdir -p /srv/intranet
echo '<h1>Intranet de la empresa</h1>' > /srv/intranet/index.html
podman run -d -q --name web -v /srv/intranet:/usr/share/nginx/html:ro nginx:1.27-alpine >/dev/null
