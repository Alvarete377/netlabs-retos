useradd -r -M -s /usr/sbin/nologin subidas
useradd -m -s /bin/bash deploy
mkdir -p /srv/web/publico/subidas /srv/app
echo '<h1>Archivo de la asociación</h1><p>Sube tus documentos.</p>' > /srv/web/publico/index.html
chown -R deploy:deploy /srv/web
chmod 750 /srv/web /srv/web/publico
chown root:root /srv/web/publico/subidas
chmod 755 /srv/web/publico/subidas
cat > /srv/app/subidas.py <<'EOF'
"""Recibe ficheros: PUT /subir/<nombre> los guarda en /srv/web/publico/subidas/."""
import os
import re
from http.server import BaseHTTPRequestHandler, HTTPServer

DEST = "/srv/web/publico/subidas"


class H(BaseHTTPRequestHandler):
    def do_PUT(self):
        name = self.path.rsplit("/", 1)[-1]
        if not re.fullmatch(r"[A-Za-z0-9._-]{1,64}", name) or name.startswith("."):
            return self.reply(400, "nombre no valido\n")
        data = self.rfile.read(int(self.headers.get("Content-Length", 0)))
        try:
            with open(os.path.join(DEST, name), "wb") as f:
                f.write(data)
        except OSError as e:
            return self.reply(500, f"Error al guardar: {e}\n")
        self.reply(201, f"guardado: /subidas/{name}\n")

    def reply(self, code, text):
        body = text.encode()
        self.send_response(code)
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def log_message(self, fmt, *args):
        print(fmt % args, flush=True)


HTTPServer(("127.0.0.1", 8000), H).serve_forever()
EOF
cat > /etc/systemd/system/subidas.service <<'EOF'
[Unit]
Description=Recepción de ficheros
After=network.target
[Service]
User=subidas
UMask=0077
ExecStart=/usr/bin/python3 /srv/app/subidas.py
Restart=on-failure
[Install]
WantedBy=multi-user.target
EOF
cat > /etc/nginx/sites-available/default <<'EOF'
server {
    listen 80 default_server;
    root /srv/web/publico;
    index index.html;
    location /subir/ {
        client_max_body_size 5m;
        proxy_pass http://127.0.0.1:8000;
    }
}
EOF
# El "atajo" de alguien para buscar ficheros como root: find con SUID.
cp /usr/bin/find /usr/local/bin/buscar
chmod 4755 /usr/local/bin/buscar
systemctl daemon-reload
systemctl enable -q --now subidas
systemctl restart nginx
