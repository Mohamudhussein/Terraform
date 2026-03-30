#!/bin/bash
yum update -y
yum install -y httpd

cat <<EOF > /var/www/html/index.html
<h1>${server_text}</h1>
<p>Environment: ${environment}</p>
EOF

systemctl enable httpd
systemctl start httpd