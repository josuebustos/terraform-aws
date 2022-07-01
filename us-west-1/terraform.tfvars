availability_zones = ["us-west-1b", "us-west-1c"]
cidr_block         = "10.0.0.0/16"

key_name              = "terraform_ca"
bastion_instance_type = "t2.micro"
app_instance_type     = "t2.micro"
db_instance_type      = "t2.micro"
