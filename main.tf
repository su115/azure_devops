terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "Igor"
  region  = "eu-west-1"
}
resource "aws_instance" "server" {
  ami           = "ami-0a8e758f5e873d1c1"
  instance_type = "t2.micro"
#  user_data = "${file("install_apache.sh")}"
  vpc_security_group_ids = [aws_security_group.web-sg.id]
  count=2
  associate_public_ip_address = true
  key_name = "id_rsa"
  tags = {
    Name = "Instance"
  }
}


resource "aws_security_group" "web-sg" {
  name = "security_group-sg"
  ingress{
	from_port = 22
	to_port = 22
	protocol = "tcp"
	cidr_blocks = ["0.0.0.0/0"]
}
  ingress{
	from_port=3000
	to_port=3000
	protocol="tcp"
	cidr_blocks=["0.0.0.0/0"]
	}
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
output "all_ip"{
value = aws_instance.server.*.public_ip

}

