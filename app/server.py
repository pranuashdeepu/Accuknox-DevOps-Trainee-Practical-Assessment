# Simple Wisecow HTTP server returning a cowsay fortune
from http.server import BaseHTTPRequestHandler, HTTPServer
import subprocess, os

PORT = int(os.environ.get("PORT", "4499"))

class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        try:
            p = subprocess.Popen(["/usr/games/fortune", "-s"], stdout=subprocess.PIPE)
            fortune, _ = p.communicate(timeout=2)
        except Exception:
            fortune = b"Have a nice day!"

        try:
            p2 = subprocess.Popen(["cowsay"], stdin=subprocess.PIPE, stdout=subprocess.PIPE)
            cowsay_out, _ = p2.communicate(fortune, timeout=2)
        except Exception:
            cowsay_out = fortune

        body = cowsay_out
        self.send_response(200)
        self.send_header("Content-Type", "text/plain; charset=utf-8")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

if __name__ == '__main__':
    httpd = HTTPServer(('', PORT), Handler)
    print(f"Wisecow server running on port {PORT}")
    httpd.serve_forever()
