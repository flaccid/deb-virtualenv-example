from art import text2art
from http.server import HTTPServer, BaseHTTPRequestHandler

host = ''
port = 8080


class SimpleHTTPRequestHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.end_headers()
        self.wfile.write(bytes(text2art("Hello, world!"), 'utf-8'))

if __name__ == "__main__":
    httpd = HTTPServer(('', port), SimpleHTTPRequestHandler)
    print(f"serving on port {port}")
    httpd.serve_forever()
