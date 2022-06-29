terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-west-2"
}

resource "aws_route53_zone" "www" {
  name = "nuronet.io"
}

resource "aws_route53_record" "www" {
  allow_overwrite = true
  name            = "nuronet.io"
  ttl             = 172800
  type            = "NS"
  zone_id         = aws_route53_zone.www.zone_id

  records = [
    aws_route53_zone.www.name_servers[0],
    aws_route53_zone.www.name_servers[1],
    aws_route53_zone.www.name_servers[2],
    aws_route53_zone.www.name_servers[3],
  ]
}


locals {
  host_names = {
    namea = "dev1.nuronet.io"
    nameb = "qa1.nuronet.io"
    namec = "api1.nuronet.io"
  } 
  ip_number = {
    ipa = "10.0.0.1"
    ipb = "10.0.0.2"
    ipc = "10.0.0.3"
  }
  host_deploy_names = zipmap(values(local.host_names),values(local.ip_number))
}


resource "aws_route53_record" "subdomains" {
  for_each        = local.host_deploy_names
  allow_overwrite = true
  zone_id         = aws_route53_zone.www.zone_id
  # zone_id         = data.aws_route53_zone.selected.zone_id
  name    = each.key
  type    = "A"
  ttl     = "300"
  records = ["${each.value}"]
}