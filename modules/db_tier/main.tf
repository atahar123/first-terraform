# App tier
# Move anything to do with the app tier creation here

# ===================             Creating an NACL           ===================
resource "aws_network_acl" "private-nacl" {
  vpc_id = var.vpc_id
  subnet_ids = [aws_subnet.db_subnet.id]

  egress {
    protocol                      = -1
    rule_no                       = 100
    action                        = "allow"
    cidr_block                    = "10.0.1.0/24"
    from_port                     = 0
    to_port                       = 0
  }

  ingress {
    protocol                      = "tcp"
    rule_no                       = 100
    action                        = "allow"
    cidr_block                    = "10.0.1.0/24"
    from_port                     = 22
    to_port                       = 22
  }

  ingress {
    protocol                      = "tcp"
    rule_no                       = 110
    action                        = "allow"
    cidr_block                    = "10.0.1.0/24"
    from_port                     = 27017
    to_port                       = 27017
  }

  ingress {
    protocol                      = "tcp"
    rule_no                       = 120
    action                        = "allow"
    cidr_block                    = "10.0.1.0/24"
    from_port                     = 1024
    to_port                       = 65535
  }

  tags                            = {
    Name                          = "${var.name}-private"
  }
}


# ===================           Launching a subnet           ===================
resource "aws_subnet" "db_subnet" {
    vpc_id                        = var.vpc_id
    cidr_block                    = "10.0.2.0/24"
    availability_zone             = "eu-west-1a"
    tags                          = {
      Name                        = "${var.name}-subnet"
    }
}


# ===================       Creating a security group        ===================
resource "aws_security_group" "db_sg" {
  name                            = "atahar_db_terra_sg"
  description                     = "Allow inbound traffic to port 80"
  vpc_id                          = var.vpc_id

  ingress {
    description                   = "allows all ports on my ip"
    from_port                     = 1024
    to_port                       = 65535
    protocol                      = "tcp"
    cidr_blocks                   = ["10.0.1.0/24"]
  }

  ingress {
    description                   = "Allows port 27017 from public subnet"
    from_port                     = 27017
    to_port                       = 27017
    protocol                      = "tcp"
    cidr_blocks                   = ["10.0.1.0/24"]
  }

  ingress {
    description                   = "Allows port 27017 from public subnet"
    from_port                     = 22
    to_port                       = 22
    protocol                      = "tcp"
    cidr_blocks                   = ["10.0.1.0/24"]
  }

  egress {
    description                   = "Allows port 27017 from public subnet"
    from_port                     = 0
    to_port                       = 0
    protocol                      = "-1"
    cidr_blocks                   = ["0.0.0.0/0"]
}

  tags                            = {
    Name                          = "${var.name}-db-sg"
  }
}


# ===================         Creating a route table         ===================
resource "aws_route_table" "private" {
    vpc_id                        = var.vpc_id


    tags                          = {
      Name                        = "${var.name}-private"
    }
}


# ===================      Creating associations (route)     ===================
resource "aws_route_table_association" "assoc" {
    subnet_id                     = aws_subnet.db_subnet.id
    route_table_id                = aws_route_table.private.id
}


# ===================         Calling template fle           ===================
data "template_file" "db_init" {
  template                        = file("./scripts/db/init.sh.tpl")

}
# ===================         Launching an instance          ===================
resource "aws_instance" "db_instance" {
    ami                           = var.ami_id
    instance_type                 = "t2.micro"
    associate_public_ip_address   = true
    subnet_id                     = aws_subnet.db_subnet.id
    vpc_security_group_ids        = [aws_security_group.db_sg.id]
    tags                          = {
        Name                      = "${var.name}-db-terra"
    }
    key_name                      = "atahar-eng54"
    user_data                     = data.template_file.db_init.rendered
  }



output "instance_ip_addr" {
value                         = aws_instance.db_instance.private_ip
}
