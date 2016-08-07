variable "stack_name" {}
variable "environment" {}
variable "vpc_id" {}
variable "key_pair_id" {}
variable "proxy_subnet_id" {}
variable "proxy_ami" {}
variable "private_key_path" {}
# variable "cassandra_instance_id" {}
variable "cassandra_dns" {}
variable "elb_sec_grp_id" {}
variable "name_prefix" {}
# variable "depends_id" {}

resource "aws_security_group" "proxy" {
  name        = "${var.name_prefix}sg_proxy"
  description = "Internal proxy security"
  vpc_id      = "${var.vpc_id}"

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # proxy and admin access from ELB
  ingress {
    from_port       = 8000
    to_port         = 8001
    protocol        = "tcp"
    # cidr_blocks     = ["0.0.0.0/0"]
    # security_groups = [ "sg-0131df67" ]
    security_groups = [ "${var.elb_sec_grp_id}"]
  }

  # kong clustering communication
  ingress {
    from_port       = 7946
    to_port         = 7946
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
    self            = true
    # security_groups  = ["sg-0131df67"] 
  }  

  # outbound internet access
  egress {
    from_port   = 1
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    stack_name = "${var.stack_name}"
    environment = "${var.environment}"
  }

}

resource "aws_instance" "proxy" {

    connection {
        user = "ec2-user"
        private_key = "${file(var.private_key_path)}"
    }

    instance_type = "t2.micro"
    key_name = "${var.key_pair_id}"
    ami = "${var.proxy_ami}"
    vpc_security_group_ids = ["${aws_security_group.proxy.id}"]
    # vpc_security_group_ids = ["sg-ff31df99"]
    associate_public_ip_address = true
    subnet_id = "${var.proxy_subnet_id}"

    provisioner "local-exec" {
        command = "sleep 300"
    }

    provisioner "local-exec" {
        command = "sed 's/{cassandra_dns}/${var.cassandra_dns}/g' ${path.module}/startup_base.sh > ${path.module}/startup.sh"
    }

    provisioner "remote-exec" {
        script = "${path.module}/startup.sh"
    }

    tags {
        Name = "${var.name_prefix}proxy"
        stack_name = "${var.stack_name}"
        environment = "${var.environment}"
    }

}

# resource "null_resource" "proxy_startup" {
#     depends_on = ["aws_instance.proxy"]

#     provisioner "local-exec" {
#       command = "scp -o StrictHostKeyChecking=no -i ${var.private_key_path} ${path.module}/kong-config.yml ec2-user@${aws_instance.proxy.public_ip}:/home/ec2-user/kong.yml"
#     }

#     # provisioner "remote-exec" {
#     #     script = "${path.module}/startup.sh"
#     # }

# }

