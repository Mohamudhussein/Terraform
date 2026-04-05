#!/bin/bash
yum update -y
yum install -y httpd

cat > /var/www/html/index.html <<EOF
<!DOCTYPE html>
<html>
<head>
  <title>Day 20 Workflow Deployment</title>
</head>
<body>
  <h1>Terraform Webserver Cluster</h1>
  <p>Application version: ${app_version}</p>
  <p>Environment: ${environment}</p>
  <p>Deployed through a Terraform workflow.</p>
</body>
</html>
EOF

cat > /etc/httpd/conf.d/custom-port.conf <<EOF
Listen ${server_port}
EOF

sed -i 's/^Listen 80/#Listen 80/' /etc/httpd/conf/httpd.conf || true

systemctl enable httpd
systemctl restart httpd