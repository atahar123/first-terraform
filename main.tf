provider "aws" {
region                            = "eu-west-1"
}

# We don't need a new IG
# We can query our existing VPC/Infrastructure with the 'data' function
data "aws_internet_gateway" "default-gw" {
  filter {
    name                          = "attachment.vpc-id"
    values                        = [var.vpc_id]
  }
}


module "app" {
  source                          = "./modules/app_tier"
  vpc_id                          = var.vpc_id
  name                            = var.name
  ami_id                          = var.ami_id
  gateway_id                      = data.aws_internet_gateway.default-gw.id
}
