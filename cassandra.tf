################################
#  INSTANCES                   #
################################
resource "aws_security_group" "cassandra" {

    name        = "sg_${var.stack_name}_cassandra_instance"
    description = "Internal proxy security"
    vpc_id      = "${aws_vpc.kong_qa.id}"

    ###############
    # SSH         #
    ###############
    ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }

    ###############
    # public      #
    ###############
    # commented as i'm super not sure why we need this
    # ingress {
    #   from_port   = 8888
    #   to_port     = 8888
    #   protocol    = "tcp"
    #   cidr_blocks = ["0.0.0.0/0"]
    # }

    ###############
    # internal    #
    ###############
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
        security_groups = ["${aws_security_group.proxy.id}"]
    }

    # allow traffic for TCP 9160 (Cassandra Thrift clients)
    ingress {
        from_port = 9160
        to_port = 9160
        protocol = "tcp"
        security_groups = ["${aws_security_group.proxy.id}"]
    }

    # // allow traffic for TCP 7199 (JMX)
    # ingress {
    #     from_port = 7199
    #     to_port = 7199
    #     protocol = "tcp"
    #     cidr_blocks = ["${var.source_cidr_block}"]
    # }

}

resource "aws_instance" "cassandra" {

	instance_type = "c3.large"
	key_name = "${var.key_name}"

	# Lookup the correct AMI based on the region we specified
	ami = "${lookup(var.aws_cassandra_amis, var.aws_region)}"

	# Our Security group to allow HTTP and SSH access
	vpc_security_group_ids = ["${aws_security_group.cassandra.id}"]

	# We're going to launch into the same subnet as our ELB. In a production
	# environment it's more common to have a separate private subnet for backend instances.
	subnet_id = "${aws_subnet.cassandra_qa_subnet.id}"

    tags {
        Name = "${var.stack_name}-cassandra"
        Application = "Kong"
        Environment = "QA"
    }

}
