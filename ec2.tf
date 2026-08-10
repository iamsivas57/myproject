 resource "aws_instance" "web1" {
     ami                   = "ami-0b2ac1bf38835e348"
     instance_type         = "t3.micro"
     key_name              = "docker"
     associate_public_ip_address = "true"
     vpc_security_group_ids = ["sg-0810027b444612edb"]
     subnet_id = "subnet-08ef3c8cb1ca5f279"
 tags = {
     Name = "my_ec2"
   }
 }  

