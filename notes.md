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
