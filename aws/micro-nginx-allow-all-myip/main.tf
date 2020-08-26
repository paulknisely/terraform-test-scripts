terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}
data "http" "myip" {
  url = "https://ipv4.icanhazip.com"
}
provider "aws" {
  profile = "default"
  region  = "us-west-2"
}
resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow all inbound traffic"
  ingress {
    # TCP (change to whatever ports you need)
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
  }
  egress {
    # Outbound traffic is set to all
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_key_pair" "key" {
  key_name   = "terraformKey"
  public_key = file("~/.ssh/terraform.pub")
}
resource "aws_instance" "www-1" {
  key_name        = aws_key_pair.key.key_name
  security_groups = ["allow_all"]
  ami             = "ami-04590e7389a6e577c"
  instance_type   = "t2.micro"
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("~/.ssh/terraform")
    host        = self.public_ip
  }
  provisioner "remote-exec" {
    inline = [
      "sudo amazon-linux-extras enable nginx1.12",
      "sudo yum -y install nginx",
      "sudo systemctl start nginx"
    ]
  }
}
