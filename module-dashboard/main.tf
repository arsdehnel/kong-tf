variable "stack_name" {}
variable "environment" {}
variable "vpc_id" {}
variable "key_pair_id" {}
variable "public_subnet_id" {}
variable "dashboard_ami" {}
variable "private_key_path" {}
variable "name_prefix" {}

resource "aws_security_group" "dashboard" {
  name        = "${var.name_prefix}sg_dashboard"
  description = "Dashboard security"
  vpc_id      = "${var.vpc_id}"

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # ingress {
  #   from_port       = 80
  #   to_port         = 80
  #   protocol        = "tcp"
  #   cidr_blocks     = ["0.0.0.0/0"]
  # }

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    stack_name = "${var.stack_name}"
    environment = "${var.environment}"
  }

}

resource "aws_instance" "dashboard" {

    connection {
        user = "ubuntu"
        private_key = "${file(var.private_key_path)}"
    }

    instance_type               = "t2.micro"
    key_name                    = "${var.key_pair_id}"
    ami                         = "${var.dashboard_ami}"
    vpc_security_group_ids      = ["${aws_security_group.dashboard.id}"]
    subnet_id                   = "${var.public_subnet_id}"
    associate_public_ip_address = true

    provisioner "remote-exec" {
        script = "${path.module}/startup.sh"
    }

    tags {
        Name = "${var.name_prefix}dashboard"
        stack_name = "${var.stack_name}"
        environment = "${var.environment}"
    }

}