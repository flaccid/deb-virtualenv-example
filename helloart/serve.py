from art import text2art
from http.server import HTTPServer, BaseHTTPRequestHandler

host = ''
port = 8080


class SimpleHTTPRequestHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.end_headers()
        self.wfile.write(bytes(text2art("Hello, world!"), 'utf-8'))


def Serve():
    httpd = HTTPServer((host, port), SimpleHTTPRequestHandler)
    print(f"server listening on {host}:{port}")
    httpd.serve_forever()


def main():
    Serve()

if __name__ == "__main__":
    main()
