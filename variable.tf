variable "myinstance-type" {
    type = string
    default = "t3.micro"
  
}
variable "client-name" {
  default = "default"
}
variable "managed_by" {
  default = "dev team"
}

variable "aws_region" {
  type    = string
  default = "ap-south-1"   # change to your region
}

variable "aws_access_key" {
  type = string
}

variable "aws_secret_key" {
  type = string
}

