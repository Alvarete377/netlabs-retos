mkdir -p /opt/tablon /var/lib/netlabs
cat > /opt/tablon/tablon.py <<'EOF'
"""Tablón de avisos: lee /etc/tablon.conf al arrancar y cada vez que recibe SIGHUP."""
import signal
from http.server import BaseHTTPRequestHandler, HTTPServer

aviso = ""


def cargar(*_):
    global aviso
    with open("/etc/tablon.conf") as f:
        for linea in f:
            if linea.startswith("aviso="):
                aviso = linea.split("=", 1)[1].strip()
    print(f"configuración cargada: {aviso}", flush=True)


class H(BaseHTTPRequestHandler):
    def do_GET(self):
        body = f"Aviso: {aviso}\n".encode()
        self.send_response(200)
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def log_message(self, fmt, *args):
        pass


cargar()
signal.signal(signal.SIGHUP, cargar)
HTTPServer(("0.0.0.0", 8080), H).serve_forever()
EOF
echo 'aviso=Horario normal de 9 a 18' > /etc/tablon.conf
cat > /etc/systemd/system/tablon.service <<'EOF'
[Unit]
Description=Tablón de avisos
After=network.target
[Service]
DynamicUser=yes
ExecStart=/usr/bin/python3 /opt/tablon/tablon.py
Restart=on-failure
[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl enable -q --now tablon
sleep 1
systemctl show -p MainPID --value tablon > /var/lib/netlabs/pid-inicial
