################################
#  ELB                         #
################################
resource "aws_security_group" "elb" {
  name        = "sg_${var.stack_name}_proxy_elb"
  description = "Public facing ELB security"
  vpc_id      = "${aws_vpc.kong_qa.id}"

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
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
}

resource "aws_elb" "kong_elb" {
  name = "${var.stack_name}-proxy-elb"

  subnets         = ["${aws_subnet.public_qa_subnet.id}"]
  security_groups = ["${aws_security_group.elb.id}"]
  instances       = ["${aws_instance.proxy.id}"]

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

}

################################
#  KONG INSTANCES              #
################################
resource "aws_security_group" "proxy" {
  name        = "sg_${var.stack_name}_proxy_instance"
  description = "Internal proxy security"
  vpc_id      = "${aws_vpc.kong_qa.id}"

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
    security_groups = [ "${aws_security_group.elb.id}" ]
  }

  # proxy and admin access from ELB
  ingress {
    from_port       = 8000
    to_port         = 8001
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
    security_groups = [ "${aws_security_group.elb.id}" ]
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

}

resource "aws_instance" "proxy" {

    connection {
        # bastion_host = "${aws_instance.bastion.id}"
        user = "ec2-user"
        key_file = "~/.ssh/${var.key_file}"
        timeout = "1m"
    }

	instance_type = "t2.micro"
	key_name = "${var.key_name}"
	ami = "${lookup(var.aws_kong_amis, var.aws_region)}"
	vpc_security_group_ids = ["${aws_security_group.proxy.id}"]
    subnet_id = "${aws_subnet.proxy_qa_subnet.id}"
    associate_public_ip_address = true

    provisioner "remote-exec" {
        inline = [
            "sudo yum -y update",
            "sudo yum -y install nginx",
            "sudo service nginx start"
        ]
    }

    tags {
        Name = "${var.stack_name}-proxy"
        Application = "Kong"
        Environment = "QA"
    }

}
