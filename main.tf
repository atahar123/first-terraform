provider "aws" {
region = "eu-west-1"
}

# ===================     Launching a subnet      ===================
resource "aws_subnet" "app_subnet" {
    vpc_id                        = "vpc-07e47e9d90d2076da"
    cidr_block                    = "172.31.0.0/24"
    availability_zone             = "eu-west-1a"
    tags                          = {
      Name                        = "ENG54-atahar_subnet_pub"
    }
}

# ===================     Launching an instance   ===================
resource "aws_instance" "app_instance" {
    ami                           = "ami-040bb941f8d94b312"
    instance_type                 = "t2.micro"
    associate_public_ip_address   = true
    subnet_id                     = "${aws_subnet.app_subnet.id} "
    vpc_security_group_ids        = [aws_security_group.app_sg.id]
    tags                          = {
        Name                      = "ENG54-atahar_app"
    }
}

# ===================     Creating a security group   ===================
resource "aws_security_group" "app_sg" {
  name                            = "atahar_terra_sg"
  description                     = "Allow inbound traffic to port 80 from anywhere"
  vpc_id                          = "vpc-07e47e9d90d2076da"

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
    Name                          = "atahar_inb_terra"
  }
}
