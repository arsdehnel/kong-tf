variable "application" {}
variable "environment" {}
variable "vpc_id" {}
variable "key_pair_id" {}
variable "public_subnet_id" {}
variable "bastion_ami" {}
variable "name_prefix" {}

resource "aws_security_group" "bastion" {
  name = "${var.name_prefix}Bastion"
  description = "Allow SSH traffic from the internet"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Application = "${var.application}"
    Environment = "${var.environment}"
  }  

}

resource "aws_security_group" "allow_access_from_bastion" {
  name = "${var.name_prefix}Allow Access From Bastion"
  description = "Grants access to SSH from bastion server"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_groups = ["${aws_security_group.bastion.id}"]
  }

  egress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Application = "${var.application}"
    Environment = "${var.environment}"
  }

}

resource "aws_instance" "bastion" {
  ami                    = "${var.bastion_ami}"
  instance_type          = "t2.micro"
  subnet_id              = "${var.public_subnet_id}"
  key_name               = "${var.key_pair_id}"
  vpc_security_group_ids = ["${aws_security_group.bastion.id}"]

  tags {
    Name = "${var.name_prefix}Bastion"
    Application = "${var.application}"
    Environment = "${var.environment}"
  }
}

resource "aws_eip" "bastion" {
  instance = "${aws_instance.bastion.id}"
  vpc = true
}