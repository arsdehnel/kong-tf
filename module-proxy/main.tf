variable "application" {}
variable "environment" {}
variable "vpc_id" {}
variable "key_pair_id" {}
variable "proxy_subnet_id" {}
variable "proxy_ami" {}
variable "private_key_path" {}
# variable "cassandra_instance_id" {}
variable "elb_sec_grp_id" {}
variable "name_prefix" {}

resource "aws_security_group" "proxy" {
  name        = "${var.name_prefix}Proxy"
  description = "Internal proxy security"
  vpc_id      = "${var.vpc_id}"

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # health check port from ELB
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
    security_groups = [ "${var.elb_sec_grp_id}" ]
  }

  # proxy and admin access from ELB
  ingress {
    from_port       = 8000
    to_port         = 8001
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
    security_groups = [ "${var.elb_sec_grp_id}" ]
  }

  # kong clustering communication
  ingress {
    from_port       = 7946
    to_port         = 7946
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
    self            = true
  }  

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Application = "${var.application}"
    Environment = "${var.environment}"
  }

}

resource "aws_instance" "proxy" {

    connection {
        # bastion_host = "${aws_instance.bastion.id}"
        user = "ec2-user"
        private_key = "${file(var.private_key_path)}"
    }

    # depends_on = ["${var.cassandra_instance_id}"]
    instance_type = "t2.micro"
    key_name = "${var.key_pair_id}"
    ami = "${var.proxy_ami}"
    vpc_security_group_ids = ["${aws_security_group.proxy.id}"]
    subnet_id = "${var.proxy_subnet_id}"

    provisioner "remote-exec" {
        script = "${path.module}/startup.sh"
    }

    tags {
        Name = "${var.name_prefix}Proxy"
        Application = "${var.application}"
        Environment = "${var.environment}"
    }

}
