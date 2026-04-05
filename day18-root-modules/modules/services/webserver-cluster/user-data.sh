#!/bin/bash
set -euxo pipefail

yum update -y
yum install -y python3

cat > /home/ec2-user/app.py <<'PYEOF'
from http.server import BaseHTTPRequestHandler, HTTPServer

class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header("Content-type", "text/plain")
        self.end_headers()
        self.wfile.write(b"Hello from the web platform")

server = HTTPServer(("0.0.0.0", 8080), Handler)
server.serve_forever()
PYEOF

chown ec2-user:ec2-user /home/ec2-user/app.py

cat > /etc/systemd/system/webapp.service <<'EOF'
[Unit]
Description=Web Platform Application
After=network.target

[Service]
User=ec2-user
WorkingDirectory=/home/ec2-user
ExecStart=/usr/bin/python3 /home/ec2-user/app.py
Restart=always

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable webapp
systemctl start webapp
systemctl status webapp --no-pager