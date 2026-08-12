 resource "aws_instance" "web1" {
     ami                   = "ami-0304448c82662e9ac"
     instance_type         = "t3.micro"
     key_name              = "fabia"
     associate_public_ip_address = "true"
     vpc_security_group_ids = ["sg-05a144405aad0533c"]
     subnet_id = "subnet-08ef3c8cb1ca5f279"
 tags = {
     Name = "my_ec2"
   }
 }  

