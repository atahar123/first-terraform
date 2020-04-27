provider "aws" {
region                            = "eu-west-1"
}

resource "aws_vpc" "app_vpc" {
    cidr_block = "10.0.0.0/16"
    tags = {
      Name = "${var.name}-vpc"
    }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.app_vpc.id

  tags = {
    Name = "${var.name}-vpc"
  }
}


# We don't need a new IG
# We can query our existing VPC/Infrastructure with the 'data' function
# data "aws_internet_gateway" "default-gw" {
#   filter {
#     name                          = "attachment.vpc-id"
#     values                        = [var.vpc_id]
#   }
# }


module "app" {
  source                          = "./modules/app_tier"
  vpc_id                          = aws_vpc.app_vpc.id
  name                            = var.name
  ami_id                          = var.ami_id
  gateway_id                      = aws_internet_gateway.igw.id
  # gateway_id                      = data.aws_internet_gateway.default-gw.id
}
