#!/bin/bash

sudo su
yum update
yum install -y nginx

TOKEN=$(curl --request PUT "http://169.254.169.254/latest/api/token" --header "X-aws-ec2-metadata-token-ttl-seconds: 3600")
IP_ADDRESS=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4 --header "X-aws-ec2-metadata-token: $TOKEN")
HOSTNAME=$(curl -s http://169.254.169.254/latest/meta-data/public-hostname --header "X-aws-ec2-metadata-token: $TOKEN")

cat <<EOF > /usr/share/nginx/html/index.html
<!DOCTYPE html>
<html>
<head>
    <title>Welcome to Nginx</title>
</head>
<body>
    <h1>Welcome to Nginx!</h1>
    <p>Hostname: $HOSTNAME</p>
    <p>IP Address: $IP_ADDRESS</p>
</body>
</html>
EOF

systemctl start nginx
systemctl enable nginx