resource "aws_iam_role" "kamma_ec2_role" {
  name = "kamma_ec2_instance_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
      tag-key = "kamma_ec2_role"
  }
}

resource "aws_iam_instance_profile" "kamma_instance_profile" {
  name = "kamma_ec2_instance_profile"
  role = "${aws_iam_role.kamma_ec2_role.name}"
}

resource "aws_iam_role_policy" "kamma_policy" {
  name = "kamma_ec2_policy"
  role = "${aws_iam_role.kamma_ec2_role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ecr:*",
        "iam:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_security_group" "kamma_ec2_sg" {
  name = "kamma-ec2-sg"
  vpc_id      = module.vpc.vpc_id
  description = "Allow SSH traffic via Terraform"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
      tag-key = "kamma-ec2-sg"
  }
}

resource "aws_instance" "kamma_ec2_instance" {
  ami = var.ami
  # k8s cluster requires 2 cpus
  instance_type = var.instance_type
  iam_instance_profile = "${aws_iam_instance_profile.kamma_instance_profile.name}"
  key_name = var.key_name
  availability_zone = element(module.vpc.azs, 0)
  subnet_id = element(module.vpc.public_subnets, 0)
  associate_public_ip_address = true 
  vpc_security_group_ids = [aws_security_group.kamma_ec2_sg.id]
  root_block_device {
    volume_size = 30
    volume_type = "gp3"
  }
 
  user_data = <<EOF
#!/bin/bash

sudo yum install git -y
sleep 5

curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
sleep 5

sudo yum update && sudo yum install docker -y
sleep 5

curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && chmod +x minikube && sudo mv minikube /usr/local/bin/
sleep 5

sudo yum install -y conntrack
sleep 5

sudo service docker start
sudo systemctl enable docker.service
sudo usermod -aG docker $USER && newgrp docker

EOF 

tags = {
      tag-key = "kamma-ec2-instance"
  }

provisioner "file" {
    source      = "check-instance.sh"
    destination = "/home/ec2-user/check-instance.sh"
    
     connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = "${file("/Users/manishvadgama/.ssh/manish-key-pair.pem")}"
      host        = "${self.public_ip}"
    }

  }

}
