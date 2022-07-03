Doesnt work with this key format
ssh-keygen -t ed25519


ssh-keygen -t rsa -b 4096
ssh-keygen -f api1_nocira_web.pub -m 'PEM' -e > api1_nocira_web.pem