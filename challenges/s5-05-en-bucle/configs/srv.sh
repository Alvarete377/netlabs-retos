useradd -r -M -s /usr/sbin/nologin tienda
mkdir -p /opt/tienda /etc/tienda
cat > /opt/tienda/cache.py <<'EOF'
"""Caché de la tienda: escucha en 127.0.0.1:6380 y responde PONG."""
import socketserver


class H(socketserver.StreamRequestHandler):
    def handle(self):
        self.wfile.write(b"PONG\n")


socketserver.TCPServer.allow_reuse_address = True
socketserver.TCPServer(("127.0.0.1", 6380), H).serve_forever()
EOF
cat > /opt/tienda/catalogo.py <<'EOF'
"""Catálogo de la tienda: carga los productos en memoria y los sirve en el puerto 8080."""
import os
import socket
import sys
from http.server import BaseHTTPRequestHandler, HTTPServer

ruta = os.environ.get("CATALOGO")
if not ruta:
    sys.exit("Falta la variable CATALOGO (fichero de productos)")
try:
    socket.create_connection(("127.0.0.1", 6380), timeout=2).close()
except OSError:
    sys.exit("No hay caché en 127.0.0.1:6380")
productos = open(ruta).read().split()
indice = bytearray(140 * 1024 * 1024)  # el índice en memoria: ~140 MB
print(f"catálogo cargado: {len(productos)} productos", flush=True)


class H(BaseHTTPRequestHandler):
    def do_GET(self):
        body = f"Tienda: {len(productos)} productos\n".encode()
        self.send_response(200)
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def log_message(self, fmt, *args):
        pass


HTTPServer(("0.0.0.0", 8080), H).serve_forever()
EOF
printf 'silla\nmesa\nlampara\nestanteria\nsofa\n' > /opt/tienda/productos.txt
echo 'CATALOGO=/opt/tienda/productos.txt' > /etc/tienda/catalogo.env
cat > /etc/systemd/system/cache.service <<'EOF'
[Unit]
Description=Caché de la tienda
[Service]
User=tienda
ExecStart=/usr/bin/python3 /opt/tienda/cache-servidor.py
Restart=on-failure
[Install]
WantedBy=multi-user.target
EOF
cat > /etc/systemd/system/catalogo.service <<'EOF'
[Unit]
Description=Catálogo de la tienda
Requires=cache.service
After=cache.service
StartLimitBurst=3
StartLimitIntervalSec=60
[Service]
User=tienda
EnvironmentFile=/etc/tienda/tienda.env
ExecStart=/usr/bin/python3 /opt/tienda/catalogo.py
Restart=on-failure
RestartSec=1
MemoryMax=64M
MemorySwapMax=0
[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl enable -q cache catalogo
systemctl start catalogo 2>/dev/null || true
