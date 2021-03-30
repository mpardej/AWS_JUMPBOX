terraform {
  required_version = ">= 0.12.13"
}

provider "aws" {
  region  = "eu-central-1"
  version = "~> 2.70.0"
}

resource "aws_security_group" "jump" {
  description = "Allow RDP access"
  vpc_id      = data.aws_vpc.vpc.id

  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.tags
}

resource "aws_instance" "jump" {
  ami                         = local.ami
  instance_type               = local.instance_type
  key_name                    = local.aws_instance_key_name
  vpc_security_group_ids      = [aws_security_group.jump.id]
  subnet_id                   = data.aws_subnet.public_subnet.id
  associate_public_ip_address = true
  
  root_block_device {
    volume_size = local.disk_size
  }

  tags = local.tags
}

resource "aws_eip" "jump" {
  instance = aws_instance.jump.id
  vpc      = true
  
  tags = local.tags
}