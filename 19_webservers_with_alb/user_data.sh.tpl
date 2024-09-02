#!/bin/bash

yum -y update
yum -y install httpd

myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`

cat <<EOF > /var/www/html/index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Title</title>
</head>
<body>
  <h1>Apache WebServer</h1>
  <p>Internal IP: <strong>$myip</strong></p>
  <p>Owner: <strong>${first_name} ${last_name}</strong></p>
</body>
</html>
EOF

systemctl start httpd
systemctl enable httpd