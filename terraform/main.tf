provider "aws" {
  region                  = "us-east-1"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "max"
  version                 = "~> 1.38"
}

data "aws_vpc" "vpc" {
  id = "vpc-14b9ca71"
}

data "aws_subnet_ids" "subnet_ids" {
  vpc_id = "${data.aws_vpc.vpc.id}"
}
