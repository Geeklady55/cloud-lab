provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "web_sg" {
  name        = "cloud-lab-web-sg"
  description = "Allow HTTP and SSH"

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow SSH from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["38.94.249.122/32"]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "cloud-lab-web-sg"
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

resource "aws_instance" "web" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  user_data = <<-EOF_SCRIPT
              #!/bin/bash
              apt update -y
              apt install nginx -y
              echo "<h1>Colleen AWS EC2 Cloud Lab</h1><p>Deployed with Terraform.</p>" > /var/www/html/index.html
              systemctl enable nginx
              systemctl start nginx
              EOF_SCRIPT

  tags = {
    Name = "cloud-lab-ec2"
  }
}

output "ec2_public_ip" {
  value = aws_instance.web.public_ip
}

output "ec2_website_url" {
  value = "http://${aws_instance.web.public_ip}"
}
