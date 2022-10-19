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
  <p>My team mates are:</p>
  <ul>
  %{for mate in team_mates ~}
      <li>${mate}</li>
  %{endfor ~}
  </ul>
</body>
</html>
EOF
#echo "<h2>WebServer with IP: $myip</h2><br>Build by Terraform using external script!"  >
#echo "<br><h3>Hello World!</h3>" >> /var/www/html/index.html

sudo service httpd start
chkconfig httpd on