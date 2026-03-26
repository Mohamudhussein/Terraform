#!/bin/bash
yum update -y
yum install -y httpd

cat > /var/www/html/index.html <<EOF
<html>
  <head><title>Terraform Day 11</title></head>
  <body>
    <h1>Terraform Conditionals Demo</h1>
    <p>Environment: ${environment}</p>
    <p>Cluster: ${cluster_name}</p>
  </body>
</html>
EOF

systemctl enable httpd
systemctl start httpd