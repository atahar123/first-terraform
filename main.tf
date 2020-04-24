provider "aws" {
region                            = "eu-west-1"
}


# ===================     Launching a subnet      ===================
resource "aws_subnet" "app_subnet" {
    vpc_id                        = var.vpc_id
    cidr_block                    = "172.31.0.0/24"
    availability_zone             = "eu-west-1a"
    tags                          = {
      Name                        = var.name
    }
}


# ===================     Creating a route table   ===================
resource "aws_route_table" "public" {
    vpc_id                        = var.vpc_id

    route {
      cidr_block                  = "0.0.0.0/0"
      gateway_id                  = data.aws_internet_gateway.default-gw.id
    }

    tags                          = {
      Name                        = "${var.name}-public-sub"
    }
}

resource "aws_route_table_association" "assoc" {
    subnet_id                     = aws_subnet.app_subnet.id
    route_table_id                = aws_route_table.public.id
}

# We don't need a new IG
# We can query our existing VPC/Infrastructure with the 'data' handler/function
data "aws_internet_gateway" "default-gw" {
  filter {
    name                          = "attachment.vpc-id"
    values                        = [var.vpc_id]
  }
}


# ===================     Launching an instance   ===================
resource "aws_instance" "app_instance" {
    ami                           = var.ami_id
    instance_type                 = "t2.micro"
    associate_public_ip_address   = true
    subnet_id                     = aws_subnet.app_subnet.id
    vpc_security_group_ids        = [aws_security_group.app_sg.id]
    tags                          = {
        Name                      = var.name
    }
}


# ===================     Creating a security group   ===================
resource "aws_security_group" "app_sg" {
  name                            = "atahar_terra_sg"
  description                     = "Allow inbound traffic to port 80 from anywhere"
  vpc_id                          = var.vpc_id

  ingress {
    description                   = "Allows port 80"
    from_port                     = 00
    to_port                       = 80
    protocol                      = "tcp"
    cidr_blocks                   = ["0.0.0.0/0"]
  }

  egress {
    from_port                     = 0
    to_port                       = 0
    protocol                      = "-1"
    cidr_blocks                   = ["0.0.0.0/0"]
  }

  tags                            = {
    Name                          = "${var.name}-tags"
  }
}