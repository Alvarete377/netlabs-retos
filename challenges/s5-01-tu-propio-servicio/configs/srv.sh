useradd -r -M -s /usr/sbin/nologin informes
mkdir -p /opt/informes
cat > /opt/informes/panel.py <<'EOF'
"""Panel de informes: HTTP en el puerto 8080."""
import getpass
from http.server import BaseHTTPRequestHandler, HTTPServer


class H(BaseHTTPRequestHandler):
    def do_GET(self):
        body = f"Panel de informes (usuario {getpass.getuser()})\n".encode()
        self.send_response(200)
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def log_message(self, fmt, *args):
        print(fmt % args, flush=True)


HTTPServer(("0.0.0.0", 8080), H).serve_forever()
EOF
