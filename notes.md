Doesnt work with this key format
ssh-keygen -t ed25519


ssh-keygen -t rsa -b 4096
ssh-keygen -f api1_nocira_web.pub -m 'PEM' -e > api1_nocira_web.pem

# dont use .pub
ssh -i terraform_ca  ec2-user@<ip-address>



#!/bin/bash
apt-get -y update
apt-get -y install nginx
service nginx start
echo fin v1.00!

### Install ArangoDB Amazon AMI Linux 2
No GUI setup
sudo apt install curl apt-transport-https

cd /etc/yum.repos.d/
sudo curl -OL https://download.arangodb.com/arangodb39/RPM/arangodb.repo
sudo yum install arangodb3-3.9.2-1.0 -y 

```

```

scp -i /Users/josuebustos/Downloads/ubuntu-arangodb.pem ec2-user@100.27.36.247:/home/ec2-user/arangod.conf arangod.conf

sudo sed -i '26 s/127.0.0.1/0.0.0.0/' /etc/arangod.conf

sudo sed -i '54 i ' nginx.conf

sudo sed -i '53 a  \n        location / {\n            allow all;\n            proxy_pass http://localhost:8529;\n            proxy_http_version 1.1;\n            proxy_set_header Upgrade $http_upgrade;\n            proxy_set_header Connection 'upgrade';\n            proxy_set_header Host $host;\n            proxy_cache_bypass $http_upgrade;\n        }' nginx.conf