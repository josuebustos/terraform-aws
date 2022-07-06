provider "aws" {
  region = "us-west-2"
}

resource "aws_vpc" "web_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "CloudAcademy"
    Demo = "Terraform"
  }
}

resource "aws_subnet" "subnet1" {
  vpc_id            = aws_vpc.web_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = var.availability_zones[0]

  tags = {
    Name = "Subnet1"
    Type = "Public"
  }
}

resource "aws_subnet" "subnet2" {
  vpc_id            = aws_vpc.web_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = var.availability_zones[1]

  tags = {
    Name = "Subnet2"
    Type = "Public"
  }
}

resource "aws_internet_gateway" "web_vpc" {
  vpc_id = aws_vpc.web_vpc.id

  tags = {
    "Name"  = "web_vpc"
    "Owner" = "CloudAcademy"
  }
}

resource "aws_route_table" "rt1" {
  vpc_id = aws_vpc.web_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.web_vpc.id
  }

  tags = {
    Name = "Public"
  }
}

resource "aws_route_table_association" "rta1" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.rt1.id
}

resource "aws_route_table_association" "rta2" {
  subnet_id      = aws_subnet.subnet2.id
  route_table_id = aws_route_table.rt1.id
}

resource "aws_security_group" "webserver" {
  name        = "Webserver"
  description = "Webserver network traffic"
  vpc_id      = aws_vpc.web_vpc.id

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.workstation_ip]
  }

  ingress {
    description = "80 from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Allow traffic"
  }
}

resource "aws_instance" "web" {
  ami                    = var.amis[var.region]
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = aws_subnet.subnet1.id
  vpc_security_group_ids = [aws_security_group.webserver.id]

  associate_public_ip_address = true

  #userdata
  
  user_data = <<EOF
#!/bin/bash
sudo yum update -y
# Install Nginx
sudo amazon-linux-extras install nginx1 -y 
sudo systemctl start nginx
sudo systemctl enable nginx
# Install Certbot Letsencrypt
sudo amazon-linux-extras install epel -y
sudo yum install certbot-nginx -y
# Install Docker
sudo amazon-linux-extras install docker -y
sudo systemctl start docker
sudo systemctl enable docker
# Install Docker Compose
sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
EOF

  tags = {
    Name = "CloudAcademy"
  }
}

resource "aws_key_pair" "my_key_pair" {
  key_name   = var.key_name
  public_key = file("/Users/josuebustos/.ssh/terraform_ca.pub")
  # public_key = file("${abspath(path.cwd)}/my-key.pub")
}

# 98.159.85.30/32