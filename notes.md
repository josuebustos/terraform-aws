ssh-keygen -t ed25519

ssh-keygen -f terraform_ca.pub -m 'PEM' -e > terraform_cc.pem