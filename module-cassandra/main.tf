variable "stack_name" {}
variable "environment" {}
variable "vpc_id" {}
variable "key_pair_id" {}
variable "cassandra_subnet_id" {}
variable "cassandra_ami" {}
variable "private_key_path" {}
variable "proxy_sec_grp_id" {}
variable "name_prefix" {}

resource "aws_security_group" "cassandra" {

    name        = "${var.name_prefix}sg_cassandra"
    description = "Internal proxy security"
    vpc_id      = "${var.vpc_id}"

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }  

    ingress {
        from_port       = 8888
        to_port         = 8888
        protocol        = "tcp"
        cidr_blocks     = ["0.0.0.0/0"]
    }    

    # tcp
    ingress {
        from_port = 0
        to_port = 65535
        protocol = "tcp"
        self = true
    }

    # udp
    ingress {
        from_port = 0
        to_port = 65535
        protocol = "udp"
        self = true
    }

    ###############
    # proxy       #
    ###############
    # allow traffic for TCP 9042 (Cassandra clients)
    ingress {
        from_port = 9042
        to_port = 9042
        protocol = "tcp"
        security_groups = ["${var.proxy_sec_grp_id}"]
    }

    # allow traffic for TCP 9160 (Cassandra Thrift clients)
    ingress {
        from_port = 9160
        to_port = 9160
        protocol = "tcp"
        security_groups = ["${var.proxy_sec_grp_id}"]
    }

    # // allow traffic for TCP 7199 (JMX)
    # ingress {
    #     from_port = 7199
    #     to_port = 7199
    #     protocol = "tcp"
    #     cidr_blocks = ["${var.source_cidr_block}"]
    # }

    tags {
        stack_name = "${var.stack_name}"
        environment = "${var.environment}"
    }

}

resource "aws_instance" "cassandra" {

    connection {
        # bastion_host = "${aws_instance.bastion.id}"
        user = "ubuntu"
        private_key = "${file(var.private_key_path)}"
    }

	instance_type = "c3.large"
	key_name = "${var.key_pair_id}"
	ami = "${var.cassandra_ami}"
	vpc_security_group_ids = ["${aws_security_group.cassandra.id}"]
    subnet_id = "${var.cassandra_subnet_id}"
    user_data = "--clustername kong-qa --totalnodes 1 --version community"
    associate_public_ip_address = true

    # provisioner "remote-exec" {
    #     script = "${path.module}/startup.sh"
    # }

    tags {
        Name = "${var.name_prefix}cassandra"
        stack_name = "${var.stack_name}"
        environment = "${var.environment}"
    }

}

resource "null_resource" "dummy_dependency" {
  depends_on = ["aws_instance.cassandra"]
}

output "depends_id" { value = "${null_resource.dummy_dependency.id}" }
