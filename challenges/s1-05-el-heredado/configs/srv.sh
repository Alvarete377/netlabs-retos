useradd -r -M -d /srv/tienda -s /usr/sbin/nologin tienda
mkdir -p /srv/tienda/datos
cat > /srv/tienda/app.py <<'EOF'
"""Backend de la tienda: cuenta visitas en /srv/tienda/datos/visitas."""
import os
from http.server import BaseHTTPRequestHandler, HTTPServer

F = "/srv/tienda/datos/visitas"


class H(BaseHTTPRequestHandler):
    def do_GET(self):
        try:
            n = int(open(F).read() or 0) if os.path.exists(F) else 0
            with open(F, "w") as f:
                f.write(str(n + 1))
            body, code = f"<h1>Tienda Online</h1><p>visitas: {n + 1}</p>\n", 200
        except OSError as e:
            body, code = f"Error interno: {e}\n", 500
        data = body.encode()
        self.send_response(code)
        self.send_header("Content-Type", "text/html; charset=utf-8")
        self.send_header("Content-Length", str(len(data)))
        self.end_headers()
        self.wfile.write(data)

    def log_message(self, fmt, *args):
        print(fmt % args, flush=True)


HTTPServer(("127.0.0.1", 8000), H).serve_forever()
EOF
chown -R root:root /srv/tienda
chmod 755 /srv/tienda /srv/tienda/datos
cat > /etc/systemd/system/tienda.service <<'EOF'
[Unit]
Description=Backend de la tienda
After=network.target
[Service]
User=tienda
WorkingDirectory=/srv/tienda
ExecStart=/usr/bin/python /srv/tienda/app.py
Restart=on-failure
RestartSec=5
[Install]
WantedBy=multi-user.target
EOF
cat > /etc/nginx/sites-available/tienda <<'EOF'
server {
    listen 127.0.0.1:80;
    server_name _;
    location / {
        proxy_pass http://127.0.0.1:8000;
    }
}
EOF
rm -f /etc/nginx/sites-enabled/default
ln -s /etc/nginx/sites-available/tienda /etc/nginx/sites-enabled/tienda
systemctl daemon-reload
systemctl enable -q tienda
systemctl start tienda 2>/dev/null || true
systemctl restart nginx
