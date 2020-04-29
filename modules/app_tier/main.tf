# App tier
# Move anything to do with the app tier creation here

# ===================             Creating an NACL           ===================
resource "aws_network_acl" "public-nacl" {
  vpc_id = var.vpc_id
  subnet_ids = [aws_subnet.app_subnet.id]

  egress {
    protocol                      = -1
    rule_no                       = 100
    action                        = "allow"
    cidr_block                    = "0.0.0.0/0"
    from_port                     = 0
    to_port                       = 0
  }

  ingress {
    protocol                      = "tcp"
    rule_no                       = 100
    action                        = "allow"
    cidr_block                    = "0.0.0.0/0"
    from_port                     = 80
    to_port                       = 80
  }

  ingress {
    protocol                      = "tcp"
    rule_no                       = 110
    action                        = "allow"
    cidr_block                    = "0.0.0.0/0"
    from_port                     = 443
    to_port                       = 443
  }

  ingress {
    protocol                      = "tcp"
    rule_no                       = 120
    action                        = "allow"
    cidr_block                    = "0.0.0.0/0"
    from_port                     = 3000
    to_port                       = 3000
  }

  ingress {
    protocol                      = "tcp"
    rule_no                       = 130
    action                        = "allow"
    cidr_block                    = "86.140.147.159/32"
    from_port                     = 22
    to_port                       = 22
  }

  ingress {
    protocol                      = "tcp"
    rule_no                       = 140
    action                        = "allow"
    cidr_block                    = "0.0.0.0/0"
    from_port                     = 1024
    to_port                       = 65535
  }

  ingress {
    protocol                      = "tcp"
    rule_no                       = 150
    action                        = "allow"
    cidr_block                    = "0.0.0.0/0"
    from_port                     = 27017
    to_port                       = 27017
  }

  # ingress {
  #   protocol                      = "tcp"
  #   rule_no                       = 140
  #   action                        = "allow"
  #   cidr_block                    = "86.140.147.159/32"
  #   from_port                     = 22
  #   to_port                       = 22
  # }


  tags                            = {
    Name                          = "${var.name}-public"
  }
}


# ===================           Launching a subnet           ===================
resource "aws_subnet" "app_subnet" {
    vpc_id                        = var.vpc_id
    cidr_block                    = "10.0.1.0/24"
    availability_zone             = "eu-west-1a"
    tags                          = {
      Name                        = var.name
    }
}


# ===================         Creating a route table         ===================
resource "aws_route_table" "public" {
    vpc_id                        = var.vpc_id

    route {
      cidr_block                  = "0.0.0.0/0"
      gateway_id                  = var.gateway_id
    }

    tags                          = {
      Name                        = "${var.name}-public-sub"
    }
}


# ===================      Creating associations (route)     ===================
resource "aws_route_table_association" "assoc" {
    subnet_id                     = aws_subnet.app_subnet.id
    route_table_id                = aws_route_table.public.id
}


# ===================         Calling template fle           ===================
data "template_file" "app_init" {
  template                        = file("./scripts/app/init.sh.tpl")
  #.tpl is like .erb to allow us to interpolate vars into static templates
  vars = {
    my_name = "${var.name} is my name sir"
    db_ip_mine = var.db_ip
  }
  # seting ports
  # for the mongodb, setting private_ip for db_host
    # AWS gives us new IPs - if we want to make one machine aware of another, this could be useful
}


# ===================         Launching an instance          ===================
resource "aws_instance" "app_instance" {
    ami                           = var.ami_id
    instance_type                 = "t2.micro"
    associate_public_ip_address   = true
    subnet_id                     = aws_subnet.app_subnet.id
    vpc_security_group_ids        = [aws_security_group.app_sg.id]
    tags                          = {
        Name                      = var.name
    }
    key_name                      = "atahar-eng54"
    user_data                     = data.template_file.app_init.rendered
  }


# ===================       Creating a security group        ===================
resource "aws_security_group" "app_sg" {
  name                            = "atahar_terra_sg"
  description                     = "Allow inbound traffic to port 80"
  vpc_id                          = var.vpc_id

  ingress {
    description                   = "Allows port 80"
    from_port                     = 00
    to_port                       = 80
    protocol                      = "tcp"
    cidr_blocks                   = ["0.0.0.0/0"]
  }

  ingress {
    description                   = "Allows port 22"
    from_port                     = 22
    to_port                       = 22
    protocol                      = "tcp"
    cidr_blocks                   = ["86.140.147.159/32"]
  }

  ingress {
    description                   = "Allows port 3000"
    from_port                     = 3000
    to_port                       = 3000
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
