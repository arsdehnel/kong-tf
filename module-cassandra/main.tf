variable "stack_name" {}
variable "environment" {}
variable "vpc_id" {}
variable "key_pair_id" {}
variable "subnet_id" {}
variable "ami" {}
variable "version" {}
variable "node_count" {
    default = "1"
}
variable "private_key_path" {}
variable "proxy_sec_grp_id" {}
variable "name_prefix" {}

resource "aws_security_group" "cassandra" {

    name        = "${var.name_prefix}sg_cassandra"
    description = "Internal proxy security"
    vpc_id      = "${var.vpc_id}"

    tags {
        stack_name = "${var.stack_name}"
        environment = "${var.environment}"
    }

    # ssh from the public internet
    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }  

    # tcp from self
    ingress {
        from_port = 0
        to_port = 65535
        protocol = "tcp"
        self = true
    }

    # udp from self
    ingress {
        from_port = 0
        to_port = 65535
        protocol = "udp"
        self = true
    }

    ###############
    # kong        #
    ###############
    # allow traffic for TCP 9042 (Cassandra clients)
    ingress {
        from_port = 9042
        to_port = 9042
        protocol = "tcp"
        # security_groups = ["${var.proxy_sec_grp_id}"]
        cidr_blocks     = ["0.0.0.0/0"]
    }

    # allow traffic for TCP 9160 (Cassandra Thrift clients)
    ingress {
        from_port = 9160
        to_port = 9160
        protocol = "tcp"
        # security_groups = ["${var.proxy_sec_grp_id}"]
        cidr_blocks     = ["0.0.0.0/0"]
    }

    # datastax opscenter
    ingress {
        from_port       = 8888
        to_port         = 8888
        protocol        = "tcp"
        cidr_blocks     = ["0.0.0.0/0"]
    }    

    # allow traffic for TCP 7199 (JMX)
    ingress {
        from_port = 7199
        to_port = 7199
        protocol = "tcp"
        cidr_blocks     = ["0.0.0.0/0"]        
        # cidr_blocks = ["${var.source_cidr_block}"]
    }

    # access out to the public internet 
    # mostly just for downloading packages and updates
    egress {
        from_port   = 1
        to_port     = 65535
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }    

}

resource "aws_instance" "cassandra" {

    connection {
        user = "ubuntu"
        private_key = "${file(var.private_key_path)}"
    }

	instance_type = "m3.medium"
	key_name = "${var.key_pair_id}"
	ami = "${var.ami}"
	vpc_security_group_ids = ["${aws_security_group.cassandra.id}"]
    subnet_id = "${var.subnet_id}"
    user_data = "--clustername ${var.name_prefix}kong-${var.environment} --totalnodes ${var.node_count} --version community --release ${var.version}"

    tags {
        Name = "${var.name_prefix}cassandra"
        stack_name = "${var.stack_name}"
        environment = "${var.environment}"
    }

}

output "dns" {
    value = "${aws_instance.cassandra.private_dns}"
}