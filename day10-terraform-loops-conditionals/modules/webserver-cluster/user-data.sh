#!/bin/bash
yum update -y
yum install -y httpd

cat > /var/www/html/index.html <<EOF
<html>
  <head><title>Terraform Webserver Cluster</title></head>
  <body>
    <h1>Hello from Terraform</h1>
    <p>Environment: ${environment}</p>
    <p>Cluster: ${cluster_name}</p>
  </body>
</html>
EOF

systemctl enable httpd
systemctl start httpd