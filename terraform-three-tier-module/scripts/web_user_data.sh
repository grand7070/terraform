#!/bin/bash

# Install NGINX
sudo yum update -y
sudo yum install -y nginx

# Extract nameserver from /etc/resolv.conf
NAMESERVER=$(cat /etc/resolv.conf | grep "nameserver" | awk '{print $2}' | head -n1)

# Get EC2 Instance info
TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
RZAZ=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/placement/availability-zone-id)
IID=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" 169.254.169.254/latest/meta-data/instance-id)
LIP=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" 169.254.169.254/latest/meta-data/local-ipv4)

# Update NGINX configuration with the extracted nameserver and the provided ALB DNS name
cat > /etc/nginx/conf.d/default.conf <<EOF
server {
    listen 80;
    resolver $NAMESERVER valid=30s;
    location / {
        proxy_pass http://${INTERNAL_ALB_DNS_NAME}:8080;
        proxy_set_header X-WEB-AZ $RZAZ;
        proxy_set_header X-WEB-IID $IID;
        proxy_set_header X-WEB-IP $LIP;
    }

    location ~ \.jsp$ {
        proxy_pass http://${INTERNAL_ALB_DNS_NAME}:8080;
        proxy_set_header X-WEB-AZ $RZAZ;
        proxy_set_header X-WEB-IID $IID;
        proxy_set_header X-WEB-IP $LIP;
    }
}
EOF

# Start NGINX
sudo service nginx start