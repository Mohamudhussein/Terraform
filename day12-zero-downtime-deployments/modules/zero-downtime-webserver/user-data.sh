#!/bin/bash
yum update -y
yum install -y httpd

cat > /var/www/html/index.html <<EOF
<html>
  <head><title>Terraform Zero Downtime</title></head>
  <body>
    <h1>Hello World ${version}</h1>
    <p>Cluster: ${cluster_name}</p>
    <p>Environment: ${environment}</p>
  </body>
</html>
EOF

systemctl enable httpd
systemctl start httpd