variable "stack_name" {}
variable "environment" {}
variable "vpc_id" {}
variable "public_subnet_id" {}
variable "proxy_instance_id" {}
variable "name_prefix" {}

resource "aws_security_group" "elb" {
  name        = "${var.name_prefix}sg_elb"
  description = "ELB security"
  vpc_id      = "${var.vpc_id}"

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # admin access
  ingress {
    from_port   = 8001
    to_port     = 8001
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }  

  # SSH from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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

resource "aws_elb" "elb" {
  name = "${var.stack_name}-${var.environment}-public-elb"

  subnets             = ["${var.public_subnet_id}"]
  security_groups     = ["${aws_security_group.elb.id}"]
  instances           = ["${var.proxy_instance_id}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  listener {
    instance_port     = 8001
    instance_protocol = "http"
    lb_port           = 8001
    lb_protocol       = "http"
  }  

  health_check {
    healthy_threshold = 3
    unhealthy_threshold = 5
    timeout = 60
    target = "TCP:80"
    interval = 90
  }

  tags {
    Name        = "${var.name_prefix}elb"
    stack_name = "${var.stack_name}"
    environment = "${var.environment}"
  }

}