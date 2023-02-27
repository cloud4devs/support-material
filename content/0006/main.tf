###################################
############    AMI     ###########
###################################

data "aws_ami" "amazon-linux-2" {
  most_recent = true

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }


  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

###################################
######    MY CURRENT IP     #######
###################################

data "http" "myip" {
  url = "https://checkip.amazonaws.com"
}

###################################
#######   SECURITY GROUP    #######
###################################

resource "aws_security_group" "instance-sg" {
  name        = "server-instance-sg"
  description = "Server Instance Security Group"

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "My Current IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.myip.response_body)}/32"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "Cloud4Devs"
  }

}

###################################
############    EC2    ############
###################################

resource "aws_instance" "this" {
  ami                    = data.aws_ami.amazon-linux-2.id
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.instance-sg.id]
  key_name               = aws_key_pair.generated_key.key_name

  tags = {
    Name = "Cloud4Devs"
  }
  user_data = <<EOF
#cloud-config
package_update: true
package_upgrade: true

runcmd:
  # Install Docker and Docker Compose
  - sudo yum update -y
  - sudo amazon-linux-extras install docker -y
  - sudo systemctl start docker
  - sudo systemctl enable docker
  - sudo usermod -a -G docker ec2-user
  - sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
  - sudo chmod +x /usr/local/bin/docker-compose
  # Install Nginx
  - sudo amazon-linux-extras list | grep epel
  - sudo amazon-linux-extras enable epel
  - sudo yum clean metadata
  - sudo yum install epel-release -y
  - sudo yum install nginx -y
  - sudo systemctl start nginx
  - sudo systemctl enable nginx
  # Install Certbot
  - sudo amazon-linux-extras install epel -y
  - sudo yum install -y certbot python2-certbot-apache
  EOF
}

###################################
########    ELASTIC IP     ########
###################################

resource "aws_eip" "instance-ip" {
  instance = aws_instance.this.id
  vpc      = true
}

output "instance_ip" {
  value = aws_eip.instance-ip.public_ip
}

###################################
#######    SSH KEY PAIR     #######
###################################

resource "tls_private_key" "ssh-key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "server-instance-key"
  public_key = tls_private_key.ssh-key.public_key_openssh
}

# SENSITIVE DATA
resource "null_resource" "key" {
  provisioner "local-exec" {
    command = <<-EOT
      echo '${tls_private_key.ssh-key.private_key_pem}' > server-instance-key
      chmod 400 server-instance-key
    EOT
  }
}