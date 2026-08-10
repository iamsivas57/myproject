# 1.VPC
resource "aws_vpc" "vpc1" {
  cidr_block = "10.0.0.0/16"

    tags = {
    Name = "${var.client-name}-vpc"
    managed_by ="${var.managed_by}"
  }
}
# 2.internet gateway
resource "aws_internet_gateway" "igw1" {
  vpc_id = aws_vpc.vpc1.id

 tags = {
    Name = "${var.client-name}-igw1"
    managed_by ="${var.managed_by}"
  }
}
# 3. public subnet 1
resource "aws_subnet" "pub_sub1" {
  vpc_id     = aws_vpc.vpc1.id
  cidr_block = "10.0.1.0/24"

 tags = {
    Name = "${var.client-name}-pub_sub1"
    managed_by ="${var.managed_by}"
  }
}
# 4. private subnet 1 
resource "aws_subnet" "priv_sub1" {
  vpc_id     = aws_vpc.vpc1.id
  cidr_block = "10.0.2.0/24"

 tags = {
    Name = "${var.client-name}-priv_sub1"
    managed_by ="${var.managed_by}"
  }
}
# 5. public route table 1
resource "aws_route_table" "pub_rt1" {
  vpc_id = aws_vpc.vpc1.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw1.id
  }
  tags = {
    Name = "${var.client-name}-pub_rt1"
    managed_by ="${var.managed_by}"
  }
}
# 6. private route table 1
resource "aws_route_table" "priv_rt1" {
  vpc_id = aws_vpc.vpc1.id

   tags = {
    Name = "${var.client-name}-priv_rt1"
    managed_by ="${var.managed_by}"
  }
}
# 7. public subnet 1 association
resource "aws_route_table_association" "pub_sub1-pub_rt1" {
  subnet_id      = aws_subnet.pub_sub1.id
  route_table_id = aws_route_table.pub_rt1.id
}
# 8. Private subnet 1 association
resource "aws_route_table_association" "priv_sub1-priv_rt1" {
  subnet_id      = aws_subnet.priv_sub1.id
  route_table_id = aws_route_table.priv_rt1.id
}
# 9. Security groups
resource "aws_security_group" "mysg1" {
  name        = "${var.client-name}-mysg1"
  # description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.vpc1.id

  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["49.47.241.28/32",aws_vpc.vpc1.cidr_block]
  }

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

   egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.client-name}-mysg1"
    managed_by ="${var.managed_by}"
  }
}
# 10.web server
resource "aws_instance" "apac1" {
    ami                   = "ami-0b2ac1bf38835e348"
    instance_type         = var.myinstance-type
    subnet_id              = aws_subnet.pub_sub1.id
    key_name              = "docker"
    associate_public_ip_address = "true"
    vpc_security_group_ids = [aws_security_group.mysg1.id]
   
tags = {
    Name = "${var.client-name}-apac1"
    managed_by ="${var.managed_by}"
  }
}  
# 11.db server
resource "aws_instance" "datab" {
    ami                    = "ami-0b2ac1bf38835e348"
    instance_type          = var.myinstance-type
    subnet_id              = aws_subnet.priv_sub1.id
    key_name               = "docker"
    vpc_security_group_ids = [aws_security_group.mysg1.id]
    

tags = {
    Name = "${var.client-name}-datab"
    managed_by ="${var.managed_by}"
  }
}  

output "apac1_public_ip" {
  value = aws_instance.apac1.public_ip
}

output "datab_private_ip" {
  value = aws_instance.datab.private_ip
}
