locals {
    ami             = "ami-07c16fb2c280ce0bf" # Windows 2016 free tier"
    instance_type   = "t2.micro"
    disk_size       = "30"
    aws_instance_key_name = "ec2-jumpbox-key"
  tags = {
    Owner       = "user"
    Environment = "dev"
  }
}